import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/habit_templates.dart';
import '../providers/onboarding_provider.dart';

class StepTemplate extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const StepTemplate({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pilih gaya hidupmu',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih yang paling cocok dengan keseharianmu.',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: onboardingTemplates.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final template = onboardingTemplates[index];
                final isSelected = state.selectedTemplate?.id == template.id;

                return AppCard(
                  onTap: () {
                    ref.read(onboardingProvider.notifier).selectTemplate(template);
                  },
                  backgroundColor: isSelected ? AppColors.primaryLight : AppColors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForTemplate(template.id),
                          color: isSelected ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.title,
                              style: AppTextStyles.h3.copyWith(
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              template.description,
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary)
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
                  onPressed: state.selectedTemplate == null ? null : onNext,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForTemplate(String id) {
    switch (id) {
      case 'morning_routine': return Icons.wb_sunny;
      case 'healthy_lifestyle': return Icons.favorite;
      case 'study_focus': return Icons.school;
      case 'mindfulness': return Icons.spa;
      default: return Icons.list;
    }
  }
}
