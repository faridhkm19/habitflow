import 'package:flutter/material.dart';

import '../constants/app_elevation.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// Variant of [AppCard].
enum AppCardVariant {
  /// Habit Card — Design_System.md §7:
  /// bg: color.surface | radius: radius.md | padding: space.md | shadow: elevation.low
  habit,

  /// Stat Card — Design_System.md §7:
  /// bg: color.surface | radius: radius.lg | padding: space.lg | shadow: elevation.low
  stat,
}

/// Reusable card container for HabitFlow.
///
/// Wraps content in a styled container with the correct background,
/// border radius, padding, and shadow as defined in Design_System.md §7 (Card).
///
/// Usage:
/// ```dart
/// AppCard(child: Text('Habit name'))               // habit variant (default)
/// AppCard(variant: AppCardVariant.stat, child: ...) // stat card
/// ```
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.habit,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
  });

  final Widget child;
  final AppCardVariant variant;

  /// Optional tap callback — adds an InkWell when provided.
  final VoidCallback? onTap;

  /// Custom padding (overrides the default from the variant spec).
  final EdgeInsetsGeometry? padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Custom background color (overrides the default surface color).
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = variant == AppCardVariant.stat
        ? AppRadius.lg
        : AppRadius.md;
    final effectivePadding =
        padding ??
        EdgeInsets.all(
          variant == AppCardVariant.stat ? AppSpacing.lg : AppSpacing.md,
        );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: effectiveRadius,
        // elevation.low shadow per Design System
        boxShadow: AppElevation.low,
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: onTap != null
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  splashColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08),
                  child: Padding(padding: effectivePadding, child: child),
                ),
              )
            : Padding(padding: effectivePadding, child: child),
      ),
    );
  }
}
