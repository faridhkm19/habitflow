import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../../domain/usecases/get_journal_logs_usecase.dart';
import 'home_provider.dart';

final getJournalLogsUseCaseProvider = Provider<GetJournalLogsUseCase>((ref) {
  final repository = ref.watch(habitLogRepositoryProvider);
  return GetJournalLogsUseCase(repository);
});

final journalSearchQueryProvider = StateProvider<String>((ref) => '');

class HabitJournalNotifier extends AsyncNotifier<List<JournalEntryEntity>> {
  @override
  Future<List<JournalEntryEntity>> build() async {
    return _fetchLogs();
  }

  Future<List<JournalEntryEntity>> _fetchLogs() async {
    final userId = ref.read(authStateProvider).valueOrNull?.id;
    if (userId == null) return [];

    final usecase = ref.read(getJournalLogsUseCaseProvider);
    final result = await usecase(userId);

    if (result.isErr) {
      throw Exception(result.failureOrNull?.message ?? 'Gagal memuat catatan');
    }

    return result.valueOrNull ?? [];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchLogs());
  }
}

final habitJournalProvider =
    AsyncNotifierProvider<HabitJournalNotifier, List<JournalEntryEntity>>(
      () => HabitJournalNotifier(),
    );

final filteredAndGroupedJournalProvider =
    Provider<Map<DateTime, List<JournalEntryEntity>>>((ref) {
      final entriesAsync = ref.watch(habitJournalProvider);
      final searchQuery = ref.watch(journalSearchQueryProvider).toLowerCase();

      if (entriesAsync.valueOrNull == null) return {};

      final entries = entriesAsync.valueOrNull!;
      final Map<DateTime, List<JournalEntryEntity>> grouped = {};

      for (final entry in entries) {
        if (searchQuery.isNotEmpty) {
          final matchName = entry.habitName.toLowerCase().contains(searchQuery);
          final matchNote =
              entry.note?.toLowerCase().contains(searchQuery) ?? false;
          if (!matchName && !matchNote) continue;
        }

        final date = DateTime(
          entry.logDate.year,
          entry.logDate.month,
          entry.logDate.day,
        );
        if (!grouped.containsKey(date)) {
          grouped[date] = [];
        }
        grouped[date]!.add(entry);
      }

      return grouped;
    });
