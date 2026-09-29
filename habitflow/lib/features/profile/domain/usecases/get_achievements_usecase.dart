import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/date_utils.dart' as date_utils;
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../logging/domain/repositories/habit_log_repository.dart';
import '../entities/achievement_entity.dart';

class GetAchievementsUseCase {
  final HabitLogRepository logRepository;

  GetAchievementsUseCase(this.logRepository);

  Future<List<AchievementEntity>> call(
    String userId,
    List<HabitEntity> habits,
  ) async {
    // 1. Dapatkan max streak dari semua habit
    int maxStreak = 0;
    for (final habit in habits) {
      if (habit.longestStreak > maxStreak) {
        maxStreak = habit.longestStreak;
      }
    }

    // 2. Dapatkan total check-in
    final totalCheckinsResult = await logRepository.getTotalCompletedCheckIns(
      userId,
    );
    final int totalCheckins = totalCheckinsResult.valueOrNull ?? 0;

    // 3. Hitung average consistency 7 hari terakhir
    double avgConsistency = 0.0;
    if (habits.isNotEmpty) {
      final today = DateTime.now();
      final fromDate = today.subtract(const Duration(days: 7));
      final logsResult = await logRepository.getLogsForDateRange(
        userId,
        fromDate,
        today,
      );
      final logs = logsResult.valueOrNull ?? [];

      int totalScheduled = 0;
      int totalCompleted = 0;

      for (int i = 0; i < 7; i++) {
        final checkDateRaw = today.subtract(Duration(days: i));
        final checkDate = DateTime(
          checkDateRaw.year,
          checkDateRaw.month,
          checkDateRaw.day,
        );

        for (final habit in habits) {
          // Hanya hitung habit yang sudah ada pada tanggal tersebut
          final createdAtLocal = habit.createdAt.toLocal();
          if (checkDate.isBefore(
            DateTime(
              createdAtLocal.year,
              createdAtLocal.month,
              createdAtLocal.day,
            ),
          )) {
            continue;
          }

          bool scheduled = false;
          if (habit.frequencyType == 'x_per_week') {
            scheduled = true; // Sederhana: anggap scheduled tiap hari
          } else {
            scheduled = date_utils.isScheduledForToday(habit, checkDate);
          }

          if (scheduled) {
            totalScheduled++;
            final completed = logs.any(
              (l) =>
                  l.habitId == habit.id &&
                  l.isCompleted &&
                  date_utils.isSameDate(l.logDate, checkDate),
            );
            if (completed) {
              totalCompleted++;
            }
          }
        }
      }
      if (totalScheduled > 0) {
        avgConsistency = (totalCompleted / totalScheduled) * 100;
      }
    }

    final activeHabitsCount = habits.where((h) => !h.isArchived).length;

    // 4. Bangun list achievements
    return [
      AchievementEntity(
        id: 'first_checkin',
        title: 'Langkah Pertama',
        description: 'Check-in pertamamu!',
        icon: Icons.check_circle_rounded,
        color: AppColors.primary,
        backgroundColor: AppColors.primaryLight,
        isUnlocked: totalCheckins >= 1,
      ),
      AchievementEntity(
        id: 'streak_7',
        title: 'Seminggu Konsisten',
        description: '7 hari streak berturut-turut',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.accent1,
        backgroundColor: AppColors.accent1Light,
        isUnlocked: maxStreak >= 7,
      ),
      AchievementEntity(
        id: 'streak_30',
        title: 'Satu Bulan Kuat',
        description: '30 hari streak berturut-turut',
        icon: Icons.emoji_events_rounded,
        color: AppColors.secondary,
        backgroundColor: AppColors.secondaryLight,
        isUnlocked: maxStreak >= 30,
      ),
      AchievementEntity(
        id: 'checkin_50',
        title: '50 Check-in',
        description: 'Sudah 50 kali check-in!',
        icon: Icons.bolt_rounded,
        color: AppColors.accent2,
        backgroundColor: AppColors.accent2Light,
        isUnlocked: totalCheckins >= 50,
      ),
      AchievementEntity(
        id: 'checkin_100',
        title: 'Centurion',
        description: '100 check-in — luar biasa!',
        icon: Icons.diamond_rounded,
        color: AppColors.primaryDark,
        backgroundColor: AppColors.primaryLight,
        isUnlocked: totalCheckins >= 100,
      ),
      AchievementEntity(
        id: 'habit_creator',
        title: 'Arsitek Kebiasaan',
        description: 'Buat 3 habit atau lebih',
        icon: Icons.widgets_rounded,
        color: AppColors.secondaryDark,
        backgroundColor: AppColors.secondaryLight,
        isUnlocked: activeHabitsCount >= 3,
      ),
      AchievementEntity(
        id: 'consistency_80',
        title: 'Si Telaten',
        description: 'Consistency score ≥ 80% selama 7 hari',
        icon: Icons.stars_rounded,
        color: AppColors.accent1,
        backgroundColor: AppColors.accent1Light,
        isUnlocked:
            avgConsistency >= 80.0 &&
            totalCheckins >= 1, // Harus ada minimal 1 check-in
      ),
    ];
  }
}
