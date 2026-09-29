/// HabitFlow Spacing Tokens
/// Source of truth: Design_System.md §4 (Spacing & Layout Grid)
///
/// System based on 4px multiples.
///
/// Usage example:
///   Padding(padding: EdgeInsets.all(AppSpacing.md))
///   SizedBox(height: AppSpacing.lg)
abstract final class AppSpacing {
  // Prevent instantiation
  AppSpacing._();

  /// space.xs — 4px — very tight gap (icon-to-text spacing)
  static const double xs = 4;

  /// space.sm — 8px — small intra-component gap
  static const double sm = 8;

  /// space.md — 16px — standard card padding, general element gap
  static const double md = 16;

  /// space.lg — 24px — section spacing
  static const double lg = 24;

  /// space.xl — 32px — page margin, large section gap
  static const double xl = 32;

  /// space.xxl — 48px — large breathing room
  static const double xxl = 48;
}
