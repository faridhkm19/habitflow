import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WeeklyRadialChart extends StatelessWidget {
  final Map<DateTime, bool?> heatmapData;
  final Color activeColor;

  const WeeklyRadialChart({
    super.key,
    required this.heatmapData,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    int completedDays = 0;
    int missedDays = 0;
    int scheduledDays = 0;
    int currentStreak = 0;
    bool streakBroken = false;

    // Calculate stats from the last 7 days of heatmapData (today down to 6 days ago)
    for (int i = 0; i < 7; i++) {
      final dateRaw = today.subtract(Duration(days: i));
      final date = DateTime(dateRaw.year, dateRaw.month, dateRaw.day);

      final status = heatmapData[date];

      if (status == true) {
        completedDays++;
        scheduledDays++;
        if (!streakBroken) currentStreak++;
      } else if (status == false) {
        missedDays++;
        scheduledDays++;
        streakBroken = true;
      }
      // If status is null, it's not scheduled. It doesn't break the streak and isn't counted in scheduledDays.
    }

    double percentage = scheduledDays == 0
        ? 0.0
        : (completedDays / scheduledDays);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          // Radial Progress (Donut Chart)
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 12,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: AppTextStyles.h1.copyWith(
                          color: activeColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Stats Breakdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatRow(
                  context,
                  Icons.check_circle_rounded,
                  activeColor,
                  'Selesai',
                  '$completedDays Hari',
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  context,
                  Icons.cancel_rounded,
                  Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  'Tidak Selesai',
                  '$missedDays Hari',
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  context,
                  Icons.local_fire_department_rounded,
                  AppColors.warning,
                  'Streak',
                  '$currentStreak Hari',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
