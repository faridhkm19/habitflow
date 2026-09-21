import 'package:flutter/material.dart';
import 'app_colors.dart';

/// HabitFlow Elevation / Shadow Tokens
/// Source of truth: Design_System.md §5 (Border Radius & Elevation)
///
/// Shadows are soft and not too sharp — consistent with "calm but fun" mood.
///
/// Usage example:
///   decoration: BoxDecoration(boxShadow: AppElevation.low)
abstract final class AppElevation {
  AppElevation._();

  /// elevation.low — blur: 8, opacity: 0.06, offset: (0, 2)
  /// Usage: habit card in a list
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0F000000), // black at ~6% opacity (0.06 × 255 ≈ 15 → 0x0F)
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// elevation.medium — blur: 16, opacity: 0.08, offset: (0, 4)
  /// Usage: bottom sheet, dropdown
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000), // black at ~8% opacity (0.08 × 255 ≈ 20 → 0x14)
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// elevation.high — blur: 24, opacity: 0.12, offset: (0, 8)
  /// Usage: confirmation dialog, modal
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x1F000000), // black at ~12% opacity (0.12 × 255 ≈ 31 → 0x1F)
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // ── Colored shadow variants ───────────────────────────────────────────────
  // For the FAB which uses elevation.medium with a primary-tinted shadow

  /// elevation.medium with primary color tint (for primary-colored FAB)
  static final List<BoxShadow> mediumPrimary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
