import 'package:flutter/material.dart';

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
}
