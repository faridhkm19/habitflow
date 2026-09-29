import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/achievement_entity.dart';

class AchievementBadgeCard extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementBadgeCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    // Styling untuk state locked vs unlocked
    final Color bgColor = achievement.isUnlocked
        ? achievement.backgroundColor
        : AppColors.neutralMissed.withValues(alpha: 0.2);

    final Color iconColor = achievement.isUnlocked
        ? achievement.color
        : AppColors.textSecondary.withValues(alpha: 0.5);

    final Color textColor = achievement.isUnlocked
        ? AppColors.textPrimary
        : AppColors.textSecondary;

    final IconData displayIcon = achievement.isUnlocked
        ? achievement.icon
        : Icons.lock_rounded;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon Badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              displayIcon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          // Judul
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Kriteria (Deskripsi)
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
