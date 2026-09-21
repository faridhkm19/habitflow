import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_log_repository.dart';
import '../datasources/habit_log_remote_datasource.dart';
import '../models/habit_log_model.dart';

class HabitLogRepositoryImpl implements HabitLogRepository {
  final HabitLogRemoteDataSource remoteDataSource;

  HabitLogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<void>> upsertLog(HabitLogEntity log) async {
    try {
      final model = HabitLogModel.fromEntity(log);
      await remoteDataSource.upsertLog(model);
      return const Ok(null);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<HabitLogEntity>>> getLogsForDate(String userId, DateTime date) async {
    try {
      final logs = await remoteDataSource.getLogsForDate(userId, date);
      return Ok(logs);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<HabitLogEntity>>> getLogsForHabit(String habitId, DateTime fromDate, DateTime toDate) async {
    try {
      final logs = await remoteDataSource.getLogsForHabit(habitId, fromDate, toDate);
      return Ok(logs);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }
}
