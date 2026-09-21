import 'package:flutter/material.dart';

/// HabitFlow Color Tokens
/// Source of truth: Design_System.md §2 (Color System)
///
/// All values are taken DIRECTLY from the Design System document.
/// Do NOT use any color value that is not listed here.
abstract final class AppColors {
  // ── Brand Colors ──────────────────────────────────────────────────────────
  // color.primary — Periwinkle Blue — CTA, active state, brand
  static const Color primary = Color(0xFF4E55E0);

  // color.secondary — Lime Green — progress, completion, achievement
  static const Color secondary = Color(0xFFB8EB6C);

  // color.accent1 — Mustard Amber — reward, badge, streak
  static const Color accent1 = Color(0xFFF7CD63);

  // color.accent2 — Bubblegum Pink — playful, decorative elements
  static const Color accent2 = Color(0xFFFC8FC6);

  // ── Tint & Shade Variations ───────────────────────────────────────────────
  // color.primary.light — soft background for selected chip, active nav item bg
  static const Color primaryLight = Color(0xFFEEEFFC);

  // color.primary.dark — pressed state for primary button
  static const Color primaryDark = Color(0xFF3A3FB0);

  // color.secondary.light — progress bar track background
  static const Color secondaryLight = Color(0xFFEEFAE0);

  // color.secondary.dark — text/icon on top of lime background
  static const Color secondaryDark = Color(0xFF8FC94A);

  // color.accent1.light — amber badge background
  static const Color accent1Light = Color(0xFFFDF3DE);

  // color.accent2.light — pink badge background
  static const Color accent2Light = Color(0xFFFEEAF4);

  // ── Neutral (Light Mode) ──────────────────────────────────────────────────
  // color.background — main app background
  static const Color background = Color(0xFFFDFBF7);

  // color.surface — card, sheet, dialog background
  static const Color surface = Color(0xFFFFFFFF);

  // color.border — divider, input outline, card border
  static const Color border = Color(0xFFE8E4DC);

  // color.text.primary — headings and main body text
  static const Color textPrimary = Color(0xFF2B2B2B);

  // color.text.secondary — supporting text, caption, placeholder
  static const Color textSecondary = Color(0xFF6E6E6E);

  // color.text.onPrimary — text on top of primary color
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic Colors ───────────────────────────────────────────────────────
  // color.success — uses secondary (Lime Green), NOT a generic green
  static const Color success = Color(0xFFB8EB6C);

  // color.warning — uses accent1 (Mustard Amber)
  static const Color warning = Color(0xFFF7CD63);

  // color.error — limited use: form validation / technical errors only
  // NOT for representing missed habit progress (that uses neutralMissed)
  static const Color error = Color(0xFFE57373);

  // color.neutralMissed — missed scheduled day; neutral, NOT punishing
  static const Color neutralMissed = Color(0xFFD8D5CE);

  // ── Habit Category Color Picker ───────────────────────────────────────────
  // All derived from brand colors to maintain palette harmony
  static const Color habitMint = Color(0xFF7AE0C4);    // Mint Green
  static const Color habitGreen = Color(0xFFB8EB6C);   // Lime Green
  static const Color habitAmber = Color(0xFFF7CD63);   // Mustard Amber
  static const Color habitPink = Color(0xFFFC8FC6);    // Bubblegum Pink
  static const Color habitSkyBlue = Color(0xFF6C9BEB); // Sky Blue (primary derivative)
  static const Color habitPeach = Color(0xFFEB8F6C);   // Peach Orange (accent complement)

  /// All available habit colors as an ordered list for the color picker UI.
  static const List<Color> habitColors = [
    habitMint,
    habitGreen,
    habitAmber,
    habitPink,
    habitSkyBlue,
    habitPeach,
  ];
}
