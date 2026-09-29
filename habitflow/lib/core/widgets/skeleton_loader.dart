import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

// ── Shimmer Mixin ─────────────────────────────────────────────────────────────

/// Base class that provides the shimmer [Animation] to skeleton widgets.
///
/// The shimmer slides from left (–1.0) to right (+2.0) over 1.4 seconds,
/// giving a smooth "light passing over a surface" effect.
class _ShimmerBase extends StatefulWidget {
  const _ShimmerBase({required this.builder});

  final Widget Function(BuildContext context, Animation<double> animation)
  builder;

  @override
  State<_ShimmerBase> createState() => _ShimmerBaseState();
}

class _ShimmerBaseState extends State<_ShimmerBase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => widget.builder(context, _animation),
    );
  }
}

// ── Gradient helper ───────────────────────────────────────────────────────────

/// Builds the shimmer gradient shader using design-token colors:
/// base = `color.border`, highlight = `color.surface`.
Shader _buildShimmerShader(Rect bounds, double shimmerPosition, bool isDark) {
  final base = isDark
      ? const Color(0xFF2E2E3A) // dark mode base tone
      : AppColors.border;
  final highlight = isDark
      ? const Color(0xFF3A3A4A) // dark mode highlight
      : AppColors.surface;

  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [base, highlight, base],
    stops: [
      shimmerPosition - 0.3,
      shimmerPosition,
      shimmerPosition + 0.3,
    ].map((s) => s.clamp(0.0, 1.0)).toList(),
  ).createShader(bounds);
}

// ── Primitive skeleton widgets ────────────────────────────────────────────────

/// A rectangular skeleton placeholder with configurable [width], [height],
/// and [borderRadius].
///
/// The shimmer highlight slides from left to right using `color.border` as
/// the base and `color.surface` as the highlight, matching Design_System.md §7.
///
/// Usage:
/// ```dart
/// SkeletonBox(width: 120, height: 16)          // narrow label
/// SkeletonBox(width: double.infinity, height: 200, borderRadius: AppRadius.lg)
/// ```
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.md,
  });

  final double width;
  final double height;

  /// Border radius applied to the rectangle — defaults to `radius.md` (12px).
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _ShimmerBase(
      builder: (context, animation) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isDark ? const Color(0xFF2E2E3A) : AppColors.border,
          ),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) =>
                _buildShimmerShader(bounds, animation.value, isDark),
            child: Container(color: Colors.white),
          ),
        );
      },
    );
  }
}

/// A circular skeleton placeholder with a configurable [diameter].
///
/// Equivalent to `SkeletonBox` with `radius.full` — convenient for avatar
/// or icon containers.
///
/// Usage:
/// ```dart
/// SkeletonCircle(diameter: 48)  // icon avatar
/// SkeletonCircle(diameter: 32)  // checkbox
/// ```
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({super.key, required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: diameter,
      height: diameter,
      borderRadius: AppRadius.full,
    );
  }
}

// ── Per-screen skeleton compositions ─────────────────────────────────────────

/// Skeleton for [HomeScreen] — matches the actual layout:
/// - Progress summary card (ring on right, two lines of text on left)
/// - 4 habit checklist rows (circle icon | two text lines | circle checkbox)
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Daily summary card skeleton
        _SkeletonCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(
                      width: 160,
                      height: 18,
                      borderRadius: AppRadius.sm,
                    ),
                    const SizedBox(height: 10),
                    SkeletonBox(
                      width: 120,
                      height: 14,
                      borderRadius: AppRadius.sm,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const SkeletonCircle(diameter: 80),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Habit rows
        for (int i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _SkeletonHabitRow(),
        ],
      ],
    );
  }
}

/// Skeleton for [HabitsListScreen] — card with circle icon, two text lines,
/// and a category chip on the right.
class HabitsListSkeleton extends StatelessWidget {
  const HabitsListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _SkeletonCard(
        child: Row(
          children: [
            const SkeletonCircle(diameter: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: double.infinity,
                    height: 15,
                    borderRadius: AppRadius.sm,
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    width: 80,
                    height: 12,
                    borderRadius: AppRadius.sm,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SkeletonBox(width: 60, height: 24, borderRadius: AppRadius.full),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for [StatisticsScreen] — bar chart area + heatmap grid area.
class StatisticsSkeleton extends StatelessWidget {
  const StatisticsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Minggu Ini" label placeholder
          SkeletonBox(width: 100, height: 18, borderRadius: AppRadius.sm),
          const SizedBox(height: 16),
          // Weekly chart area (Donut + Stats)
          _SkeletonCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  const SkeletonCircle(diameter: 96),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SkeletonStatRow(),
                        const SizedBox(height: 16),
                        _SkeletonStatRow(),
                        const SizedBox(height: 16),
                        _SkeletonStatRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // "Heatmap" label placeholder
          SkeletonBox(width: 80, height: 18, borderRadius: AppRadius.sm),
          const SizedBox(height: 16),
          // Heatmap grid
          _SkeletonCard(
            child: GridView.count(
              crossAxisCount: 13,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List.generate(
                52,
                (_) => SkeletonBox(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: AppRadius.sm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [HabitJournalScreen] — date header + 2–3 journal cards per group.
class JournalSkeleton extends StatelessWidget {
  const JournalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Group 1
        SkeletonBox(width: 80, height: 12, borderRadius: AppRadius.sm),
        const SizedBox(height: 12),
        for (int i = 0; i < 2; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _SkeletonJournalCard(),
        ],
        const SizedBox(height: 24),
        // Group 2
        SkeletonBox(width: 80, height: 12, borderRadius: AppRadius.sm),
        const SizedBox(height: 12),
        for (int i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _SkeletonJournalCard(),
        ],
      ],
    );
  }
}

/// Skeleton for [HabitDetailScreen] — icon area, two text lines, two stat
/// cards side by side, and a calendar grid area.
class HabitDetailSkeleton extends StatelessWidget {
  const HabitDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header — large centered icon + two text lines
          Center(
            child: Column(
              children: [
                const SkeletonCircle(diameter: 96),
                const SizedBox(height: 16),
                SkeletonBox(width: 180, height: 22, borderRadius: AppRadius.sm),
                const SizedBox(height: 10),
                SkeletonBox(width: 80, height: 14, borderRadius: AppRadius.sm),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Two stat cards side-by-side
          Row(
            children: [
              Expanded(
                child: _SkeletonCard(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 48,
                        height: 28,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 60,
                        height: 12,
                        borderRadius: AppRadius.sm,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SkeletonCard(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 48,
                        height: 28,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 60,
                        height: 12,
                        borderRadius: AppRadius.sm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Calendar grid area
          _SkeletonCard(
            child: Column(
              children: [
                // Month header
                SkeletonBox(width: 120, height: 16, borderRadius: AppRadius.sm),
                const SizedBox(height: 16),
                // 5-week grid (7×5)
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(
                    35,
                    (_) => SkeletonBox(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: AppRadius.sm,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for [AchievementsScreen] — grid of badge cards (circle + 2 lines).
class AchievementsSkeleton extends StatelessWidget {
  const AchievementsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        9,
        (_) => _SkeletonCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SkeletonCircle(diameter: 48),
              const SizedBox(height: 10),
              SkeletonBox(width: 60, height: 12, borderRadius: AppRadius.sm),
              const SizedBox(height: 6),
              SkeletonBox(width: 40, height: 10, borderRadius: AppRadius.sm),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for [ProfileScreen] — avatar circle + 2 lines of text + menu rows.
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar + name header
          Column(
            children: [
              const SkeletonCircle(diameter: 100),
              const SizedBox(height: 16),
              Center(
                child: SkeletonBox(
                  width: 140,
                  height: 18,
                  borderRadius: AppRadius.sm,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SkeletonBox(
                  width: 100,
                  height: 13,
                  borderRadius: AppRadius.sm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _SkeletonCard(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 24,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 56,
                        height: 12,
                        borderRadius: AppRadius.sm,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SkeletonCard(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 24,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 56,
                        height: 12,
                        borderRadius: AppRadius.sm,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SkeletonCard(
                  child: Column(
                    children: [
                      SkeletonBox(
                        width: 40,
                        height: 24,
                        borderRadius: AppRadius.sm,
                      ),
                      const SizedBox(height: 8),
                      SkeletonBox(
                        width: 56,
                        height: 12,
                        borderRadius: AppRadius.sm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Menu section label
          SkeletonBox(width: 80, height: 13, borderRadius: AppRadius.sm),
          const SizedBox(height: 12),
          // Menu rows
          for (int i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _SkeletonMenuRow(),
          ],
        ],
      ),
    );
  }
}

// ── Private composable building blocks ───────────────────────────────────────

/// Internal card container that matches `AppCard` visual — surface bg + md radius.
class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: AppRadius.md,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// One habit row: circle icon | two text lines | circle checkbox.
class _SkeletonHabitRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      child: Row(
        children: [
          const SkeletonCircle(diameter: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: double.infinity,
                  height: 15,
                  borderRadius: AppRadius.sm,
                ),
                const SizedBox(height: 8),
                SkeletonBox(width: 80, height: 12, borderRadius: AppRadius.sm),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonCircle(diameter: 32),
        ],
      ),
    );
  }
}

/// One journal entry card: circle icon + two lines of text.
class _SkeletonJournalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      child: Row(
        children: [
          const SkeletonCircle(diameter: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(
                  width: double.infinity,
                  height: 14,
                  borderRadius: AppRadius.sm,
                ),
                const SizedBox(height: 6),
                SkeletonBox(width: 120, height: 12, borderRadius: AppRadius.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One settings menu row: circle icon placeholder + text + arrow.
class _SkeletonMenuRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      child: Row(
        children: [
          const SkeletonCircle(diameter: 32),
          const SizedBox(width: 12),
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: 14,
              borderRadius: AppRadius.sm,
            ),
          ),
          const SizedBox(width: 12),
          const SkeletonCircle(diameter: 16),
        ],
      ),
    );
  }
}

/// One row for weekly stats breakdown
class _SkeletonStatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SkeletonCircle(diameter: 28),
        const SizedBox(width: 12),
        Expanded(
          child: SkeletonBox(
            width: double.infinity,
            height: 14,
            borderRadius: AppRadius.sm,
          ),
        ),
        const SizedBox(width: 8),
        const SkeletonBox(width: 40, height: 14, borderRadius: AppRadius.sm),
      ],
    );
  }
}
