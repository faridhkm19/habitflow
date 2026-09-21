import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/onboarding_provider.dart';

class StepCompletion extends ConsumerWidget {
  final VoidCallback onBack;

  const StepCompletion({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final selectedCount = state.includedHabitNames.length;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 56,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Siap memulai!',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '$selectedCount habit siap dimulai!\nKamu bisa mengubahnya kapan saja.',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
          const Spacer(),
          Row(
            children: [
              AppButton(
                label: 'Kembali',
                onPressed: state.isLoading ? null : onBack,
                variant: AppButtonVariant.secondary,
                isFullWidth: false,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  label: 'Simpan & Mulai',
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : () async {
                    final success = await ref.read(onboardingProvider.notifier).saveHabits();
                    if (success && context.mounted) {
                      context.go('/home');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
