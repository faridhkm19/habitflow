import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/onboarding_provider.dart';

class StepCustomize extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepCustomize({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final template = state.selectedTemplate;

    if (template == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pilih habit yang kamu mau', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text(
            'Pilih mana yang mau kamu mulai,\nbuang yang belum perlu.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: template.habits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = template.habits[index];
                final isIncluded = state.includedHabitNames.contains(
                  habit.name,
                );

                return AppCard(
                  onTap: () {
                    ref
                        .read(onboardingProvider.notifier)
                        .toggleHabitInclusion(habit.name);
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconData(habit.iconName),
                          color: Color(
                            int.parse(habit.colorHex.replaceFirst('#', '0xff')),
                          ),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(habit.name, style: AppTextStyles.bodyLarge),
                      ),
                      Checkbox(
                        value: isIncluded,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          ref
                              .read(onboardingProvider.notifier)
                              .toggleHabitInclusion(habit.name);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppButton(
                label: 'Kembali',
                onPressed: onBack,
                variant: AppButtonVariant.secondary,
                isFullWidth: false,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  label: 'Lanjut',
                  onPressed: state.includedHabitNames.isEmpty ? null : onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      // Rutinitas Pagi
      case 'alarm_on':
        return Icons.alarm_on;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'restaurant':
        return Icons.restaurant;
      case 'edit_note':
        return Icons.edit_note;
      // Gaya Hidup Sehat
      case 'local_drink':
        return Icons.local_drink;
      case 'bedtime':
        return Icons.bedtime;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'no_food':
        return Icons.no_food;
      // Fokus Belajar
      case 'menu_book':
        return Icons.menu_book;
      case 'notes':
        return Icons.notes;
      case 'no_cell':
        return Icons.no_cell;
      case 'app_blocking':
        return Icons.app_blocking;
      case 'quiz':
        return Icons.quiz;
      // Mindfulness
      case 'self_improvement':
        return Icons.self_improvement;
      case 'favorite':
        return Icons.favorite;
      case 'do_not_disturb':
        return Icons.do_not_disturb;
      case 'air':
        return Icons.air;
      default:
        return Icons.check_circle_outline;
    }
  }
}
