import '../../../../core/errors/failures.dart';
import '../entities/habit_log_entity.dart';
import '../entities/journal_entry_entity.dart';

abstract class HabitLogRepository {
  Future<Result<void>> upsertLog(HabitLogEntity log);
  Future<Result<List<HabitLogEntity>>> getLogsForDate(String userId, DateTime date);
  Future<Result<List<HabitLogEntity>>> getLogsForHabit(String habitId, DateTime fromDate, DateTime toDate);
  Future<Result<List<HabitLogEntity>>> getLogsForDateRange(String userId, DateTime fromDate, DateTime toDate);
  Future<Result<List<JournalEntryEntity>>> getJournalLogs(String userId);
  Future<Result<int>> getTotalCompletedCheckIns(String userId);
}

