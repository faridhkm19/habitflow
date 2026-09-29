import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Stat card dengan warna background berbeda per kartu.
/// Angka besar menggunakan text.numberLarge (28px Bold).
/// Label pendek agar tidak terpotong.
class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const ProfileStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveIconColor = (isDark && iconColor == AppColors.secondaryDark)
        ? AppColors.secondary
        : iconColor;

    final effectiveBgColor = isDark
        ? effectiveIconColor.withValues(alpha: 0.15)
        : backgroundColor;

    final effectiveBorder = isDark
        ? Border.all(color: effectiveIconColor.withValues(alpha: 0.3), width: 1)
        : null;

    final effectiveValueColor = isDark ? Colors.white : AppColors.textPrimary;

    final effectiveLabelColor = isDark
        ? Colors.white70
        : AppColors.textSecondary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(16),
          border: effectiveBorder,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon dalam bulatan kecil
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? effectiveIconColor.withValues(alpha: 0.25)
                    : effectiveIconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: effectiveIconColor, size: 18),
            ),
            const SizedBox(height: 10),
            // Angka besar — text.numberLarge sesuai Design System
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: effectiveValueColor,
              ),
            ),
            const SizedBox(height: 4),
            // Label pendek, satu baris
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: effectiveLabelColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
