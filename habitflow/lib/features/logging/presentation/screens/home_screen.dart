import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/checkin_bottom_sheet.dart';
import '../widgets/daily_progress_ring.dart';
import '../widgets/habit_checklist_item.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
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

  void _handleHabitTap(String habitId, String habitName, bool isCompleted) async {
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
            onSave: (mood, note) => notifier.saveCheckin(habitId, mood: mood, note: note),
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
    final userName = userEmail.isNotEmpty ? userEmail.split('@')[0] : 'Pengguna';
    
    final homeAsync = ref.watch(homeProvider);
    
    // Format tanggal
    final today = DateTime.now();
    final dateFormatter = DateFormat('EEEE, d MMMM', 'id_ID');
    final dateString = dateFormatter.format(today);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, $userName! 👋',
              style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
      body: homeAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data:\n$err',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_available_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Kosong untuk hari ini',
                    style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ada habit yang dijadwalkan.\nWaktunya bersantai!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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
                // ── Progress Ring ────────────────────────────────────────────────
                Center(
                  child: DailyProgressRing(
                    progress: progress,
                    completedCount: completedCount,
                    totalCount: totalCount,
                  ),
                ),
                const SizedBox(height: 32),
                
                // ── Habit Checklist ──────────────────────────────────────────────
                ...state.todayHabits.map((habit) {
                  final log = state.logsMap[habit.id];
                  final isCompleted = log?.isCompleted ?? false;
                  
                  final streakAsync = ref.watch(currentStreakProvider(habit.id));
                  final streak = streakAsync.valueOrNull ?? 0;
                  
                  return HabitChecklistItem(
                    habit: habit,
                    isCompleted: isCompleted,
                    streak: streak,
                    onTap: () => _handleHabitTap(habit.id, habit.name, isCompleted),
                    onCardTap: () => context.push('/habits/${habit.id}', extra: habit),
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
