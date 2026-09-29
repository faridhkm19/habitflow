import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/loading_indicator.dart';

// Splash screen — ditampilkan saat app pertama dibuka sambil menunggu cek auth state
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'HabitFlow',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Branded spinner — Kategori 3: color.primary, 40px, strokeWidth 3px
            const LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
