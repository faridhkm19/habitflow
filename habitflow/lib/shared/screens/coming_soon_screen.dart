import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Layar placeholder untuk fitur yang belum selesai dibangun.
/// Menampilkan ikon, nama fitur, fase rilis, dan pesan ringkas.
class ComingSoonScreen extends StatelessWidget {
  final String title;
  final String phase;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.phase,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 36),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  phase,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Fitur ini sedang dalam pengembangan dan akan hadir di pembaruan berikutnya.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
