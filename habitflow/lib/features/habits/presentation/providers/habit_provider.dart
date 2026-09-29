import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../data/datasources/habit_remote_datasource.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/create_batch_habits_usecase.dart';
import '../../domain/usecases/get_habits_usecase.dart';
import '../../domain/entities/habit_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

// --- Datasource & Repository ---
final habitRemoteDataSourceProvider = Provider<HabitRemoteDataSource>((ref) {
  return HabitRemoteDataSourceImpl(Supabase.instance.client);
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final remoteDataSource = ref.watch(habitRemoteDataSourceProvider);
  return HabitRepositoryImpl(remoteDataSource);
});

// --- Use Cases ---
final getHabitsUseCaseProvider = Provider<GetHabitsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

final createBatchHabitsUseCaseProvider = Provider<CreateBatchHabitsUseCase>((
  ref,
) {
  final repository = ref.watch(habitRepositoryProvider);
  return CreateBatchHabitsUseCase(repository);
});

// --- State Providers ---
final userHasHabitsProvider = FutureProvider<bool>((ref) async {
  final getHabits = ref.watch(getHabitsUseCaseProvider);
  final result = await getHabits();

  if (result.isOk) {
    return result.valueOrNull!.isNotEmpty;
  }

  return false;
});

class HabitsNotifier extends AsyncNotifier<List<HabitEntity>> {
  @override
  Future<List<HabitEntity>> build() async {
    final getHabits = ref.watch(getHabitsUseCaseProvider);
    final result = await getHabits();

    if (result.isOk) {
      return result.valueOrNull ?? [];
    } else {
      throw Exception('Failed to load habits');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
    ref.invalidate(profileDataProvider);
  }

  Future<String?> createHabit({
    required String name,
    required String iconName,
    required String colorHex,
    required String category,
    required String frequencyType,
    required Map<String, dynamic> frequencyValue,
  }) async {
    final authState = ref.read(authStateProvider);
    final userId = authState.value?.id;
    if (userId == null) return 'Sesi tidak valid, silakan login ulang.';

    final newHabit = HabitEntity(
      id: '',
      userId: userId,
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      category: category,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final createBatch = ref.read(createBatchHabitsUseCaseProvider);
    final res = await createBatch([newHabit]);
    if (res.isOk) {
      await refresh();
      return null;
    }
    return res.failureOrNull?.message ?? 'Gagal menyimpan habit.';
  }

  Future<String?> updateHabit({
    required String id,
    required String name,
    required String iconName,
    required String colorHex,
    required String category,
    required String frequencyType,
    required Map<String, dynamic> frequencyValue,
  }) async {
    final repo = ref.read(habitRepositoryProvider);
    final currentHabits = state.valueOrNull ?? [];
    final currentHabit = currentHabits.firstWhere((h) => h.id == id);

    final updatedHabit = HabitEntity(
      id: currentHabit.id,
      userId: currentHabit.userId,
      name: name,
      iconName: iconName,
      colorHex: colorHex,
      category: category,
      frequencyType: frequencyType,
      frequencyValue: frequencyValue,
      isArchived: currentHabit.isArchived,
      longestStreak: currentHabit.longestStreak,
      createdAt: currentHabit.createdAt,
      updatedAt: DateTime.now(),
    );

    final res = await repo.updateHabit(updatedHabit);
    if (res.isOk) {
      await refresh();
      return null;
    }
    return res.failureOrNull?.message ?? 'Gagal menyimpan perubahan.';
  }

  Future<String?> archiveHabit(String id) async {
    final repo = ref.read(habitRepositoryProvider);
    final res = await repo.archiveHabit(id);
    if (res.isOk) {
      await refresh();
      return null;
    }
    return res.failureOrNull?.message ?? 'Gagal mengarsipkan habit.';
  }

  Future<String?> deleteHabit(String id) async {
    final repo = ref.read(habitRepositoryProvider);
    final res = await repo.deleteHabit(id);
    if (res.isOk) {
      await refresh();
      return null;
    }
    return res.failureOrNull?.message ??
        'Gagal menghapus habit secara permanen.';
  }
}

final habitsProvider = AsyncNotifierProvider<HabitsNotifier, List<HabitEntity>>(
  () => HabitsNotifier(),
);
