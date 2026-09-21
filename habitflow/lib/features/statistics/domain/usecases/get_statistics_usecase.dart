import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../logging/domain/repositories/habit_log_repository.dart';
import '../entities/habit_statistics.dart';

class GetStatisticsUseCase {
  final HabitLogRepository logRepository;

  GetStatisticsUseCase({required this.logRepository});

  Future<Result<HabitStatistics>> call(HabitEntity habit) async {
    final today = DateTime.now();
    // Fetch logs for the last 365 days
    final fromDate = today.subtract(const Duration(days: 365));
    
    final logsResult = await logRepository.getLogsForHabit(habit.id, fromDate, today);
    if (logsResult.isErr) return Err(logsResult.failureOrNull!);
    
    final logs = logsResult.valueOrNull!;



    // Annual heatmap (365 days)
    Map<DateTime, bool?> annualHeatmap = {};
    for (int i = 0; i <= 365; i++) {
      // Create date without time components to avoid timezone/time matching issues
      final checkDateRaw = today.subtract(Duration(days: 365 - i));
      final checkDate = DateTime(checkDateRaw.year, checkDateRaw.month, checkDateRaw.day);
      
      final createdAtLocal = habit.createdAt.toLocal();
      if (checkDate.isBefore(DateTime(createdAtLocal.year, createdAtLocal.month, createdAtLocal.day))) {
        // Before habit was created, consider it not scheduled
        annualHeatmap[checkDate] = null;
        continue;
      }

      bool scheduled = false;
      if (habit.frequencyType == 'x_per_week') {
        // For x_per_week, it's flexible, so we consider all days since creation as 'scheduled'
        // But for visual purposes, maybe only mark days with logs as completed/missed, 
        // and others as missed if the week failed? 
        // For simplicity in heatmap, if it's x_per_week, let's treat every day as "scheduled" 
        // to encourage daily check-ins, or only count completed.
        // Actually, let's just mark it as scheduled.
        scheduled = true; 
      } else {
        scheduled = date_utils.isScheduledForToday(habit, checkDate);
      }

      bool completed = logs.any((l) => l.isCompleted && date_utils.isSameDate(l.logDate, checkDate));

      if (completed) {
        annualHeatmap[checkDate] = true;
      } else if (scheduled) {
        annualHeatmap[checkDate] = false; // Missed
      } else {
        annualHeatmap[checkDate] = null; // Not scheduled
      }
    }

    return Ok(HabitStatistics(
      annualHeatmap: annualHeatmap,
    ));
  }
}
