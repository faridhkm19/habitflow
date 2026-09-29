import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class StepWelcome extends StatelessWidget {
  final VoidCallback onNext;

  const StepWelcome({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Placeholder ikon besar / ilustrasi
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Selamat datang di HabitFlow!',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Bangun kebiasaan baik,\nsatu langkah kecil setiap harinya.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          AppButton(label: 'Mulai', onPressed: onNext, isFullWidth: true),
        ],
      ),
    );
  }
}
