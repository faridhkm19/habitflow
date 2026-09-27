import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../logging/domain/entities/habit_log_entity.dart';
import '../../../../core/widgets/app_card.dart';

class MoodCorrelationSection extends StatelessWidget {
  final List<HabitLogEntity> logs;

  const MoodCorrelationSection({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) return const SizedBox.shrink();

    // Hitung completion rate untuk tiap mood
    Map<String, int> moodTotal = {'good': 0, 'neutral': 0, 'tired': 0};
    Map<String, int> moodCompleted = {'good': 0, 'neutral': 0, 'tired': 0};

    for (var log in logs) {
      if (log.mood != null && moodTotal.containsKey(log.mood)) {
        moodTotal[log.mood!] = moodTotal[log.mood!]! + 1;
        if (log.isCompleted) {
          moodCompleted[log.mood!] = moodCompleted[log.mood!]! + 1;
        }
      }
    }

    // Jika tidak ada data mood sama sekali
    if (moodTotal['good'] == 0 && moodTotal['neutral'] == 0 && moodTotal['tired'] == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Korelasi Mood & Penyelesaian', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              _buildMoodRow('Semangat', '😊', moodCompleted['good']!, moodTotal['good']!, AppColors.secondary),
              const SizedBox(height: 12),
              _buildMoodRow('Biasa', '😐', moodCompleted['neutral']!, moodTotal['neutral']!, AppColors.accent1),
              const SizedBox(height: 12),
              _buildMoodRow('Lelah', '😔', moodCompleted['tired']!, moodTotal['tired']!, AppColors.neutralMissed),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodRow(String label, String emoji, int completed, int total, Color color) {
    final double percentage = total > 0 ? (completed / total) : 0.0;
    final int percentInt = (percentage * 100).round();

    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 24), // Memberi jarak agar bar lebih pendek
            child: Stack(
              alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
              ),
              if (percentage > 0)
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
        ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '$percentInt%',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: total > 0 ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
