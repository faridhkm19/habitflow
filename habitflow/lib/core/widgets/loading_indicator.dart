import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Simple loading indicator using the brand primary color.
///
/// Usage:
/// ```dart
/// const LoadingIndicator()          // default size
/// LoadingIndicator(size: 48)        // larger
/// LoadingIndicator(color: AppColors.secondary)  // custom color
/// ```
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size = 32,
    this.strokeWidth = 3.0,
    this.color,
  });

  /// Diameter of the circular indicator.
  final double size;

  /// Stroke width of the circular progress ring.
  final double strokeWidth;

  /// Color of the indicator — defaults to [AppColors.primary].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
        backgroundColor: AppColors.primaryLight,
      ),
    );
  }
}
