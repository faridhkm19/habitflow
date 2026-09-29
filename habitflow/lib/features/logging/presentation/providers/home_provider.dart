import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../data/datasources/habit_log_remote_datasource.dart';
import '../../data/repositories/habit_log_repository_impl.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_log_repository.dart';
import '../../../../core/providers/current_date_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../profile/presentation/providers/achievement_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';
import 'habit_journal_provider.dart';

// ── Providers untuk logging ───────────────────────────────────────────────────

final habitLogRemoteDataSourceProvider = Provider<HabitLogRemoteDataSource>((ref) {
  return HabitLogRemoteDataSourceImpl(supabaseClient: Supabase.instance.client);
});

final habitLogRepositoryProvider = Provider<HabitLogRepository>((ref) {
  final ds = ref.watch(habitLogRemoteDataSourceProvider);
  return HabitLogRepositoryImpl(remoteDataSource: ds);
});

// ── Home State ────────────────────────────────────────────────────────────────

class HomeState {
  final List<HabitEntity> todayHabits;
  final Map<String, HabitLogEntity?> logsMap; // habitId → log hari ini
  final bool isLoading;

  const HomeState({
    this.todayHabits = const [],
    this.logsMap = const {},
    this.isLoading = false,
  });

  HomeState copyWith({
    List<HabitEntity>? todayHabits,
    Map<String, HabitLogEntity?>? logsMap,
    bool? isLoading,
  }) {
    return HomeState(
      todayHabits: todayHabits ?? this.todayHabits,
      logsMap: logsMap ?? this.logsMap,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Hitung jumlah habit yang sudah completed hari ini
  int get completedCount =>
      todayHabits.where((h) => logsMap[h.id]?.isCompleted == true).length;

  double get progressRatio =>
      todayHabits.isEmpty ? 0.0 : completedCount / todayHabits.length;
}

// ── Home Notifier ─────────────────────────────────────────────────────────────

class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    // Watch habitsProvider agar saat ada habit baru/diubah, HomeState ikut ter-rebuild
    ref.watch(habitsProvider);
    // Watch currentDateProvider agar saat hari berganti, list habit hari ini diperbarui
    ref.watch(currentDateProvider);
    return _loadTodayData();
  }

  Future<HomeState> _loadTodayData() async {
    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;
    if (userId == null) return const HomeState();

    final today = DateTime.now();

    // Ambil semua habit user
    final allHabits = await ref.read(habitsProvider.future);

    // Filter habit yang aktif dan terjadwal hari ini
    final todayHabits = allHabits
        .where((h) => !h.isArchived && date_utils.isScheduledForToday(h, today))
        .toList();

    // Ambil semua log hari ini dari Supabase
    final logRepo = ref.read(habitLogRepositoryProvider);
    final logsResult = await logRepo.getLogsForDate(userId, today);

    Map<String, HabitLogEntity?> logsMap = {};
    if (logsResult.isOk) {
      final logs = logsResult.valueOrNull ?? [];
      for (final log in logs) {
        logsMap[log.habitId] = log;
      }
    }

    return HomeState(
      todayHabits: todayHabits,
      logsMap: logsMap,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadTodayData());
  }

  /// Toggle complete/uncomplete dengan optimistic update
  Future<void> toggleComplete(String habitId) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;
    if (userId == null) return;

    final existingLog = currentState.logsMap[habitId];
    final isCurrentlyCompleted = existingLog?.isCompleted == true;
    final newIsCompleted = !isCurrentlyCompleted;

    // ── Optimistic update ─────────────────────────────────────────────────────
    final today = DateTime.now();
    final optimisticLog = HabitLogEntity(
      id: existingLog?.id ?? '',
      habitId: habitId,
      userId: userId,
      logDate: today,
      isCompleted: newIsCompleted,
      mood: existingLog?.mood,
      note: existingLog?.note,
      createdAt: existingLog?.createdAt ?? today,
    );

    final newLogsMap = Map<String, HabitLogEntity?>.from(currentState.logsMap);
    newLogsMap[habitId] = optimisticLog;
    state = AsyncValue.data(currentState.copyWith(logsMap: newLogsMap));

    // ── Sinkron ke Supabase ───────────────────────────────────────────────────
    final logRepo = ref.read(habitLogRepositoryProvider);
    final result = await logRepo.upsertLog(optimisticLog);

    if (result.isErr) {
      // Rollback jika gagal
      final rollbackMap = Map<String, HabitLogEntity?>.from(currentState.logsMap);
      state = AsyncValue.data(currentState.copyWith(logsMap: rollbackMap));
      // Lempar error agar UI bisa tampilkan SnackBar
      throw result.failureOrNull?.message ?? 'Gagal menyimpan. Coba lagi.';
    }

    ref.invalidate(profileDataProvider);
    ref.invalidate(statisticsDataProvider);
    ref.invalidate(habitJournalProvider);
    ref.invalidate(achievementsProvider);
  }

  /// Simpan mood dan catatan ke log yang sudah ada (setelah bottom sheet)
  Future<void> saveCheckin(String habitId, {String? mood, String? note}) async {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;
    if (userId == null) return;

    final today = DateTime.now();
    final existingLog = currentState.logsMap[habitId];

    final updatedLog = HabitLogEntity(
      id: existingLog?.id ?? '',
      habitId: habitId,
      userId: userId,
      logDate: today,
      isCompleted: true,
      mood: mood,
      note: note,
      createdAt: existingLog?.createdAt ?? today,
    );

    // Update state lokal dulu
    final newLogsMap = Map<String, HabitLogEntity?>.from(currentState.logsMap);
    newLogsMap[habitId] = updatedLog;
    state = AsyncValue.data(currentState.copyWith(logsMap: newLogsMap));

    // Sinkron ke Supabase
    final logRepo = ref.read(habitLogRepositoryProvider);
    final result = await logRepo.upsertLog(updatedLog);

    if (result.isErr) {
      throw result.failureOrNull?.message ?? 'Gagal menyimpan catatan.';
    }

    ref.invalidate(profileDataProvider);
    ref.invalidate(statisticsDataProvider);
    ref.invalidate(habitJournalProvider);
    ref.invalidate(achievementsProvider);
  }
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  () => HomeNotifier(),
);
