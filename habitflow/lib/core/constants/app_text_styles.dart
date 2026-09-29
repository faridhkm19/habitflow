import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// HabitFlow Typography Scale
/// Source of truth: Design_System.md §3 (Typography)
///
/// Typeface: Poppins (primary) via google_fonts package.
/// All font sizes, weights, and line heights are taken DIRECTLY from the doc.
///
/// Usage example:
///   Text('HabitFlow', style: AppTextStyles.h1)
abstract final class AppTextStyles {
  // ── Type Scale ────────────────────────────────────────────────────────────
  // Each entry maps exactly to a row in Design_System.md §3 Type Scale table.

  /// text.display — 32px, Bold 700, LineHeight 40px
  /// Usage: large headings on splash / onboarding screens
  static TextStyle get display => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height:
        40 / 32, // Flutter uses height as a multiplier: lineHeight / fontSize
  );

  /// text.h1 — 24px, SemiBold 600, LineHeight 32px
  /// Usage: page titles (e.g. "Habits", "Statistics")
  static TextStyle get h1 => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
  );

  /// text.h2 — 20px, SemiBold 600, LineHeight 28px
  /// Usage: section titles, large card headings
  static TextStyle get h2 => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  /// text.h3 — 16px, SemiBold 600, LineHeight 24px
  /// Usage: habit card title, sub-headings
  static TextStyle get h3 => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
  );

  /// text.bodyLarge — 16px, Regular 400, LineHeight 24px
  /// Usage: primary body text
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  /// text.bodyMedium — 14px, Regular 400, LineHeight 20px
  /// Usage: secondary body text, descriptions
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  /// text.bodySmall — 12px, Regular 400, LineHeight 16px
  /// Usage: caption, small labels, timestamps
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );

  /// text.button — 14px, Medium 500, LineHeight 20px
  /// Usage: button labels
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
  );

  /// text.numberLarge — 28px, Bold 700, LineHeight 34px
  /// Usage: large numbers — streak count, consistency score, progress %
  static TextStyle get numberLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 34 / 28,
  );
}
