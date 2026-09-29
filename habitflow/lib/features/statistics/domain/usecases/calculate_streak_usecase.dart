import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../habits/domain/repositories/habit_repository.dart';
import '../../../logging/domain/repositories/habit_log_repository.dart';

class CalculateStreakUseCase {
  final HabitLogRepository logRepository;
  final HabitRepository habitRepository;

  CalculateStreakUseCase({
    required this.logRepository,
    required this.habitRepository,
  });

  Future<Result<int>> call(HabitEntity habit) async {
    final today = DateTime.now();
    // Gunakan tanggal 1 Januari 2020 sebagai fallback jika tidak ada logs
    final fromDate = habit.createdAt;

    final logsResult = await logRepository.getLogsForHabit(
      habit.id,
      fromDate,
      today,
    );
    if (logsResult.isErr) return Err(logsResult.failureOrNull!);

    final logs = logsResult.valueOrNull!;

    int streak = 0;
    bool graceUsed = false;

    if (habit.frequencyType == 'x_per_week') {
      final targetTimes = habit.frequencyValue['times'] as int? ?? 1;

      // x_per_week dihitung per minggu kalender (Senin - Minggu).
      // Minggu ini (current week) masih berjalan (pending), belum dianggap miss,
      // sehingga iterasi streak dimulai dari minggu sebelumnya.
      DateTime startOfCurrentWeek = _getStartOfWeek(today);
      DateTime currentWeekStart = startOfCurrentWeek.subtract(
        const Duration(days: 7),
      );

      while (true) {
        final currentWeekEnd = currentWeekStart.add(const Duration(days: 6));

        // Stop jika minggu yang sedang dicek sudah berakhir sebelum habit dibuat
        if (currentWeekEnd.isBefore(fromDate) &&
            !date_utils.isSameDate(currentWeekEnd, fromDate)) {
          break;
        }

        int completionsThisWeek = 0;
        for (var log in logs) {
          if (log.isCompleted &&
              (log.logDate.isAfter(currentWeekStart) ||
                  date_utils.isSameDate(log.logDate, currentWeekStart)) &&
              (log.logDate.isBefore(currentWeekEnd) ||
                  date_utils.isSameDate(log.logDate, currentWeekEnd))) {
            completionsThisWeek++;
          }
        }

        if (completionsThisWeek >= targetTimes) {
          streak++;
        } else if (!graceUsed) {
          graceUsed = true; // Grace period 1 minggu
        } else {
          break; // Streak putus
        }

        currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
      }
    } else {
      // daily atau specific_days
      DateTime checkDate = today;

      while (true) {
        // Stop jika checkDate sebelum habit dibuat
        if (checkDate.isBefore(fromDate) &&
            !date_utils.isSameDate(checkDate, fromDate)) {
          break;
        }

        if (!date_utils.isScheduledForToday(habit, checkDate)) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }

        bool completed = logs.any(
          (l) => l.isCompleted && date_utils.isSameDate(l.logDate, checkDate),
        );

        if (completed) {
          streak++;
        } else if (!graceUsed) {
          graceUsed = true; // Grace period 1 hari
        } else {
          break; // Streak putus
        }

        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    // Update longest streak jika rekor terpecahkan
    if (streak > habit.longestStreak) {
      await habitRepository.updateLongestStreak(habit.id, streak);
    }

    return Ok(streak);
  }

  DateTime _getStartOfWeek(DateTime date) {
    int dayOfWeek = date.weekday;
    return date.subtract(Duration(days: dayOfWeek - 1)); // 1 = Monday
  }
}
