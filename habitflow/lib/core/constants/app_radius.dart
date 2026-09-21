import 'package:flutter/material.dart';

/// HabitFlow Border Radius Tokens
/// Source of truth: Design_System.md §5 (Border Radius & Elevation)
///
/// Style decision: "medium rounded" — fun but not extreme squircle.
///
/// Usage example:
///   decoration: BoxDecoration(borderRadius: AppRadius.md)
abstract final class AppRadius {
  AppRadius._();

  // ── Raw double values ─────────────────────────────────────────────────────

  /// radius.sm — 8px — chip, small badge, input field
  static const double smValue = 8;

  /// radius.md — 12px — habit card, standard button
  static const double mdValue = 12;

  /// radius.lg — 16px — large card, bottom sheet, dialog
  static const double lgValue = 16;

  /// radius.xl — 24px — hero elements (progress ring container, onboarding illustration)
  static const double xlValue = 24;

  /// radius.full — 999px — avatar, FAB, pill button
  static const double fullValue = 999;

  // ── BorderRadius objects (ready to use) ───────────────────────────────────

  /// radius.sm as BorderRadius
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smValue));

  /// radius.md as BorderRadius
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdValue));

  /// radius.lg as BorderRadius
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgValue));

  /// radius.xl as BorderRadius
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlValue));

  /// radius.full as BorderRadius
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullValue));

  // ── BorderRadius for top-only (used by bottom sheets) ────────────────────

  /// radius.lg top-only — bottom sheet top corners
  static const BorderRadius lgTop = BorderRadius.only(
    topLeft: Radius.circular(lgValue),
    topRight: Radius.circular(lgValue),
  );

  // ── RoundedRectangleBorder (for ThemeData shapes) ─────────────────────────

  /// radius.sm as RoundedRectangleBorder
  static const RoundedRectangleBorder smShape =
      RoundedRectangleBorder(borderRadius: sm);

  /// radius.md as RoundedRectangleBorder
  static const RoundedRectangleBorder mdShape =
      RoundedRectangleBorder(borderRadius: md);

  /// radius.lg as RoundedRectangleBorder
  static const RoundedRectangleBorder lgShape =
      RoundedRectangleBorder(borderRadius: lg);

  /// radius.full as RoundedRectangleBorder
  static const RoundedRectangleBorder fullShape =
      RoundedRectangleBorder(borderRadius: full);
}
