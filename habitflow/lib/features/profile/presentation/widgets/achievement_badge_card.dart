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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Styling untuk state locked vs unlocked
    final Color bgColor = achievement.isUnlocked
        ? (isDark ? achievement.color.withValues(alpha: 0.15) : achievement.backgroundColor)
        : (isDark ? Colors.white10 : AppColors.neutralMissed.withValues(alpha: 0.2));

    final Color iconColor = achievement.isUnlocked
        ? achievement.color
        : AppColors.textSecondary.withValues(alpha: 0.5);

    final Color textColor = achievement.isUnlocked
        ? (isDark ? Colors.white : AppColors.textPrimary)
        : (isDark ? Colors.white54 : AppColors.textSecondary);

    final Color descColor = isDark ? Colors.white70 : AppColors.textSecondary;

    final IconData displayIcon = achievement.isUnlocked
        ? achievement.icon
        : Icons.lock_rounded;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
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
                  color: descColor,
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
