import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../logging/domain/repositories/habit_log_repository.dart';

class CalculateConsistencyScoreUseCase {
  final HabitLogRepository logRepository;

  CalculateConsistencyScoreUseCase({
    required this.logRepository,
  });

  Future<Result<double>> call(HabitEntity habit) async {
    final today = DateTime.now();
    final windowStart = today.subtract(const Duration(days: 29)); // 30 days inclusive
    
    // Fallback if habit was created recently
    final fromDate = habit.createdAt.isAfter(windowStart) ? habit.createdAt : windowStart;
    
    final logsResult = await logRepository.getLogsForHabit(habit.id, fromDate, today);
    if (logsResult.isErr) return Err(logsResult.failureOrNull!);
    
    final logs = logsResult.valueOrNull!;
    
    int totalScheduled = 0;
    int totalCompleted = 0;
    
    if (habit.frequencyType == 'x_per_week') {
      final targetTimes = habit.frequencyValue['times'] as int? ?? 1;
      
      // Hitung durasi sebenarnya dalam window (bisa kurang dari 30 jika habit baru dibuat)
      final daysInWindow = today.difference(fromDate).inDays + 1;
      
      // Proporsikan target berdasarkan durasi window
      totalScheduled = ((daysInWindow / 7) * targetTimes).round();
      if (totalScheduled == 0 && targetTimes > 0) {
          totalScheduled = 1; // Minimal 1 jika habit baru dibuat dan ada target
      }
      
      // Hitung total completed dalam window
      for (var log in logs) {
        if (log.isCompleted && 
            (log.logDate.isAfter(fromDate) || date_utils.isSameDate(log.logDate, fromDate)) &&
            (log.logDate.isBefore(today) || date_utils.isSameDate(log.logDate, today))) {
          totalCompleted++;
        }
      }
    } else {
      // daily atau specific_days
      for (int i = 0; i < 30; i++) {
        DateTime checkDate = today.subtract(Duration(days: i));
        
        // Skip jika hari sebelum habit dibuat
        if (checkDate.isBefore(fromDate) && !date_utils.isSameDate(checkDate, fromDate)) {
          continue;
        }
        
        if (date_utils.isScheduledForToday(habit, checkDate)) {
          totalScheduled++;
          bool completed = logs.any((l) => l.isCompleted && date_utils.isSameDate(l.logDate, checkDate));
          if (completed) {
            totalCompleted++;
          }
        }
      }
    }
    
    if (totalScheduled == 0) return const Ok(0.0);
    
    double score = (totalCompleted / totalScheduled) * 100;
    if (score > 100.0) score = 100.0;
    
    return Ok(double.parse(score.toStringAsFixed(1)));
  }
}
