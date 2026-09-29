import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/habit_entity.dart';
import '../../../statistics/presentation/providers/streak_provider.dart';

class HabitCard extends ConsumerWidget {
  final HabitEntity habit;
  final VoidCallback? onTap;
  final bool showCategory;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitColor = ColorExtension.fromHex(habit.colorHex);
    final bgColor = getLighterColor(habitColor, 0.15);

    final streakAsync = ref.watch(currentStreakProvider(habit.id));
    final currentStreak = streakAsync.valueOrNull ?? 0;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(
              getHabitIcon(habit.iconName),
              color: habitColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: AppTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$currentStreak Hari Streak',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showCategory) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _getCategoryDisplayName(habit.category),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'health':
        return 'Kesehatan';
      case 'learning':
        return 'Belajar';
      case 'mindfulness':
        return 'Mindful';
      case 'productivity':
        return 'Produktivitas';
      case 'social':
        return 'Sosial';
      case 'custom':
        return 'Lainnya';
      default:
        return category;
    }
  }
}
