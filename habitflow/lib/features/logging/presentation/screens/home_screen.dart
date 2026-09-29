import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/checkin_bottom_sheet.dart';
import '../widgets/daily_progress_ring.dart';
import '../widgets/habit_checklist_item.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../statistics/presentation/providers/streak_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).refresh();
    });
  }

  void _handleHabitTap(
    String habitId,
    String habitName,
    bool isCompleted,
  ) async {
    final notifier = ref.read(homeProvider.notifier);

    try {
      await notifier.toggleComplete(habitId);

      // Jika baru saja ditandai selesai (dari false -> true), munculkan bottom sheet
      if (!isCompleted && mounted) {
        // Beri sedikit delay agar animasi checklist selesai dulu
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          await CheckinBottomSheet.show(
            context,
            habitName: habitName,
            onSave: (mood, note) =>
                notifier.saveCheckin(habitId, mood: mood, note: note),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userEmail = authState.value?.email ?? '';
    final userName = userEmail.isNotEmpty
        ? userEmail.split('@')[0]
        : 'Pengguna';

    final homeAsync = ref.watch(homeProvider);

    // Format tanggal
    final today = DateTime.now();
    final dateFormatter = DateFormat('EEEE, d MMMM', 'id_ID');
    final dateString = dateFormatter.format(today);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, $userName! 👋',
              style: AppTextStyles.h1.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: homeAsync.when(
        // Kategori 1: skeleton mencerminkan layout asli (progress ring + habit rows)
        loading: () => const HomeScreenSkeleton(),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data:\n$err',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(homeProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (state) {
          final totalCount = state.todayHabits.length;
          final completedCount = state.completedCount;
          final progress = state.progressRatio;

          if (totalCount == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.event_available_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Kosong untuk hari ini',
                    style: AppTextStyles.h2.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ada habit yang dijadwalkan.\nWaktunya bersantai!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(homeProvider.notifier).refresh(),
            color: AppColors.primary,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              children: [
                // ── Daily Summary Card ──────────────────────────────────────────
                _DailySummaryCard(
                  progress: progress,
                  completedCount: completedCount,
                  totalCount: totalCount,
                ),
                const SizedBox(height: 32),

                // ── Habit Checklist ──────────────────────────────────────────────
                ...state.todayHabits.map((habit) {
                  final log = state.logsMap[habit.id];
                  final isCompleted = log?.isCompleted ?? false;

                  final streakAsync = ref.watch(
                    currentStreakProvider(habit.id),
                  );
                  final streak = streakAsync.valueOrNull ?? 0;

                  return HabitChecklistItem(
                    habit: habit,
                    isCompleted: isCompleted,
                    streak: streak,
                    onTap: () =>
                        _handleHabitTap(habit.id, habit.name, isCompleted),
                    onCardTap: () =>
                        context.push('/habits/${habit.id}', extra: habit),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  final double progress;
  final int completedCount;
  final int totalCount;

  const _DailySummaryCard({
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = progress >= 1.0 && totalCount > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String titleText;
    if (progress == 0) {
      titleText = 'Ayo mulai harimu!';
    } else if (isComplete) {
      titleText = 'Luar biasa! Semua selesai!';
    } else if (progress >= 0.5) {
      titleText = 'Sedikit lagi selesai!';
    } else {
      titleText = 'Terus semangat!';
    }

    // Menggunakan AppColors.primaryLight agar selaras dengan warna tema,
    // namun disesuaikan opacity-nya di dark mode agar tetap terbaca.
    final backgroundColor = isDark
        ? AppColors.primary.withValues(alpha: 0.15)
        : AppColors.primaryLight;

    final textColor = isDark ? Colors.white : AppColors.primaryDark;

    return AppCard(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completedCount dari $totalCount habit selesai',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          DailyProgressRing(progress: progress, size: 80, strokeWidth: 8),
        ],
      ),
    );
  }
}
