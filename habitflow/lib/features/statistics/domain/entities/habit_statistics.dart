// lib/features/statistics/domain/entities/habit_statistics.dart

class HabitStatistics {
  final Map<DateTime, bool?>
  annualHeatmap; // true = completed, false = missed, null = not scheduled

  HabitStatistics({required this.annualHeatmap});
}
