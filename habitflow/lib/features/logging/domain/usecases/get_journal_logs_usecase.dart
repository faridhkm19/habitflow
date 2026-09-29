import '../../../../core/errors/failures.dart';
import '../entities/journal_entry_entity.dart';
import '../repositories/habit_log_repository.dart';

class GetJournalLogsUseCase {
  final HabitLogRepository repository;

  GetJournalLogsUseCase(this.repository);

  Future<Result<List<JournalEntryEntity>>> call(String userId) {
    return repository.getJournalLogs(userId);
  }
}
