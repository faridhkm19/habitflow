import 'package:flutter/material.dart';

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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon dalam bulatan kecil
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(height: 10),
            // Angka besar — text.numberLarge sesuai Design System
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            // Label pendek, satu baris
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
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
