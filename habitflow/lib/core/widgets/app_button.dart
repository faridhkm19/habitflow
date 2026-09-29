import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_text_styles.dart';

/// Variant of [AppButton].
enum AppButtonVariant {
  /// Primary Button — Design_System.md §7:
  /// bg: color.primary | text: color.text.onPrimary | radius: radius.md
  /// padding: v14 h24
  primary,

  /// Secondary Button — Design_System.md §7:
  /// transparent bg | border: 1.5px color.primary | text: color.primary
  secondary,

  /// Text Button — Design_System.md §7:
  /// no bg/border | text: color.primary
  text,

  /// Error/Destructive Button:
  /// bg: color.error | text: color.text.onPrimary
  error,
}

/// Reusable button widget for HabitFlow.
///
/// Covers all three button variants defined in Design_System.md §7 (Component Library → Button).
/// Handles disabled state: opacity 40% per Design_System.md §8 (Component States).
///
/// Usage:
/// ```dart
/// AppButton(label: 'Masuk', onPressed: () {})                         // primary
/// AppButton(label: 'Batal', variant: AppButtonVariant.secondary, ...) // secondary
/// AppButton(label: 'Skip',  variant: AppButtonVariant.text, ...)      // text
/// AppButton(label: '...', onPressed: null)                            // disabled
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  /// When true, shows a CircularProgressIndicator instead of the label.
  final bool isLoading;

  /// When true (default), button expands to full available width.
  final bool isFullWidth;

  /// Optional leading icon.
  final IconData? prefixIcon;

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild();

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = _PrimaryButton(
          onPressed: _isDisabled ? null : onPressed,
          child: child,
        );
      case AppButtonVariant.secondary:
        button = _SecondaryButton(
          onPressed: _isDisabled ? null : onPressed,
          child: child,
        );
      case AppButtonVariant.text:
        button = _TextButtonWidget(
          onPressed: _isDisabled ? null : onPressed,
          child: child,
        );
      case AppButtonVariant.error:
        button = _ErrorButton(
          onPressed: _isDisabled ? null : onPressed,
          child: child,
        );
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: (variant == AppButtonVariant.primary || variant == AppButtonVariant.error)
              ? AppColors.textOnPrimary
              : AppColors.primary,
        ),
      );
    }

    if (prefixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(prefixIcon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}

// ── Private button implementations ────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
        disabledForegroundColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
        elevation: 0,
        shape: AppRadius.mdShape,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: AppTextStyles.button,
      ),
      child: child,
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
        side: BorderSide(
          color: onPressed == null
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.primary,
          width: 1.5,
        ),
        shape: AppRadius.mdShape,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: AppTextStyles.button,
      ),
      child: child,
    );
  }
}

class _TextButtonWidget extends StatelessWidget {
  const _TextButtonWidget({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: AppTextStyles.button,
      ),
      child: child,
    );
  }
}

class _ErrorButton extends StatelessWidget {
  const _ErrorButton({required this.onPressed, required this.child});
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.4),
        disabledForegroundColor: AppColors.textOnPrimary.withValues(alpha: 0.7),
        elevation: 0,
        shape: AppRadius.mdShape,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: AppTextStyles.button,
      ),
      child: child,
    );
  }
}
