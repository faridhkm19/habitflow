import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Branded loading indicator for HabitFlow.
///
/// Used for processes that cannot be skeletonised — app initialisation,
/// post-login/logout redirect, and first-time onboarding.
///
/// Design token compliance (Design_System.md §7, Kategori 3):
/// - Color   : `color.primary` (#4E55E0)
/// - Size    : 40px (medium)
/// - Stroke  : 3px
///
/// Usage:
/// ```dart
/// const LoadingIndicator()                       // 40px branded
/// LoadingIndicator(size: 24)                     // smaller variant
/// LoadingIndicator(color: AppColors.secondary)   // custom color
/// ```
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 40,
    this.strokeWidth = 3.0,
    this.color,
  });

  /// Diameter of the circular indicator. Defaults to 40px per Design System.
  final double size;

  /// Stroke width. Defaults to 3px per Design System.
  final double strokeWidth;

  /// Stroke color — defaults to `color.primary` ([AppColors.primary]).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
      ),
    );
  }
}
