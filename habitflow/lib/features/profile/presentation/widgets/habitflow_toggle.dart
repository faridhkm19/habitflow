import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Custom animated toggle switch sesuai spesifikasi Motion di Design_System.md:
/// - Durasi: 200ms | Easing: easeInOut
/// - OFF: background color.border (abu-abu muted)
/// - ON: background color.primary (periwinkle blue)
/// - Thumb: lingkaran putih yang bergeser kiri↔kanan dengan animasi smooth
class HabitFlowToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const HabitFlowToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const double _width = 52;
  static const double _height = 30;
  static const double _thumbSize = 22;
  static const double _padding = 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_height / 2),
          color: value ? AppColors.primary : AppColors.border,
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: _thumbSize,
              height: _thumbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
