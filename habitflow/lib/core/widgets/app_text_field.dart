import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_text_styles.dart';

/// Reusable text input field for HabitFlow.
///
/// Spec from Design_System.md §7 (Component Library → Input Field):
/// - Background: color.surface
/// - Border: 1px color.border → 1.5px color.primary on focus
/// - Radius: radius.sm (8px)
/// - Padding: vertical 14px, horizontal 16px
/// - Floating label above border when focused/filled
/// - Focus state: border changes to color.primary (Design_System.md §8)
///
/// Usage:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'Masukkan email kamu',
///   controller: _emailController,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.initialValue,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;

  /// For note fields — max 1 line by default per Design System conventions.
  final int maxLines;

  /// Optional character limit (e.g. 100 for habit notes per PRD §6 FR-3).
  final int? maxLength;

  final IconData? prefixIcon;

  /// Custom suffix widget (e.g. password visibility toggle).
  final Widget? suffixIcon;

  final bool autofocus;
  final String? initialValue;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _isObscured,
      enabled: widget.enabled,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      initialValue: widget.initialValue,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,

        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                size: 20,
                color: AppColors.textSecondary,
              )
            : null,

        // Password visibility toggle or custom suffix
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              )
            : widget.suffixIcon,

        // Counter styling for fields with maxLength
        counterStyle:
            AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),

        // All border and fill specs come from AppTheme.light inputDecorationTheme
        // but we set them here too for standalone usage outside MaterialApp
        filled: true,
        fillColor: widget.enabled ? AppColors.surface : AppColors.background,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide:
              BorderSide(color: AppColors.border.withValues(alpha: 0.5), width: 1),
        ),

        labelStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        floatingLabelStyle:
            AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
        hintStyle:
            AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
    );
  }
}
