import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/router/app_router.dart';
import '../../../statistics/presentation/widgets/calendar_section.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_provider.dart';
import '../../../statistics/presentation/providers/streak_provider.dart';
import '../../../logging/presentation/providers/recent_habit_logs_provider.dart';
import '../widgets/recent_logs_section.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final HabitEntity habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  String _getCategoryDisplayName(String categoryId) {
    switch (categoryId) {
      case 'health': return 'Kesehatan';
      case 'learning': return 'Belajar';
      case 'mindfulness': return 'Mindful';
      case 'productivity': return 'Produktivitas';
      case 'social': return 'Sosial';
      case 'custom': return 'Lainnya';
      default: return 'Kategori';
    }
  }

  void _archiveHabit() async {
    final confirm = await _showConfirmDialog(
      'Arsipkan Habit',
      'Habit ini akan disembunyikan dari daftar utama, namun riwayat log akan tetap tersimpan. Lanjutkan?',
    );
    if (!confirm) return;

    final errorMessage = await ref.read(habitsProvider.notifier).archiveHabit(widget.habit.id);
    if (errorMessage == null && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Gagal mengarsipkan habit.')),
      );
    }
  }

  void _deleteHabit() async {
    final confirm = await _showConfirmDialog(
      'Hapus Permanen',
      'Apakah Anda yakin ingin menghapus habit ini? Semua data riwayat log juga akan ikut terhapus. Tindakan ini tidak bisa dibatalkan.',
      isDestructive: true,
    );
    if (!confirm) return;

    final errorMessage = await ref.read(habitsProvider.notifier).deleteHabit(widget.habit.id);
    if (errorMessage == null && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Gagal menghapus habit secara permanen.')),
      );
    }
  }

  Future<bool> _showConfirmDialog(String title, String content, {bool isDestructive = false}) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.h2),
          content: Text(content, style: AppTextStyles.bodyMedium),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal', style: AppTextStyles.button.copyWith(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                isDestructive ? 'Hapus' : 'Ya, Lanjutkan',
                style: AppTextStyles.button.copyWith(color: isDestructive ? AppColors.error : AppColors.primary),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = ColorExtension.fromHex(widget.habit.colorHex);
    final streakAsync = ref.watch(currentStreakProvider(widget.habit.id));
    final consistencyAsync = ref.watch(consistencyScoreProvider(widget.habit.id));
    final recentLogsAsync = ref.watch(recentHabitLogsProvider(widget.habit.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Habit'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textPrimary),
            onPressed: () {
              context.push('${AppRoutes.habits}/${widget.habit.id}/edit', extra: widget.habit);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: getLighterColor(habitColor, 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      getHabitIcon(widget.habit.iconName),
                      color: habitColor,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.habit.name,
                    style: AppTextStyles.display,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getCategoryDisplayName(widget.habit.category),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Stats
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    variant: AppCardVariant.stat,
                    child: Column(
                      children: [
                        streakAsync.when(
                          data: (streak) => Text('$streak', style: AppTextStyles.numberLarge.copyWith(color: AppColors.warning)),
                          loading: () => const SizedBox(
                            width: 24, height: 24, 
                            child: CircularProgressIndicator(color: AppColors.warning, strokeWidth: 2)
                          ),
                          error: (e, st) => Text('-', style: AppTextStyles.numberLarge.copyWith(color: AppColors.warning)),
                        ),
                        const SizedBox(height: 4),
                        Text('Hari Streak', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppCard(
                    variant: AppCardVariant.stat,
                    child: Column(
                      children: [
                        consistencyAsync.when(
                          data: (score) => Text(
                            score % 1 == 0 ? '${score.toInt()}%' : '$score%', 
                            style: AppTextStyles.numberLarge.copyWith(color: AppColors.secondaryDark)
                          ),
                          loading: () => const SizedBox(
                            width: 24, height: 24, 
                            child: CircularProgressIndicator(color: AppColors.secondaryDark, strokeWidth: 2)
                          ),
                          error: (e, st) => Text('-', style: AppTextStyles.numberLarge.copyWith(color: AppColors.secondaryDark)),
                        ),
                        const SizedBox(height: 4),
                        Text('Konsistensi', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kalender Bulanan terintegrasi
            CalendarSection(habit: widget.habit),
            const SizedBox(height: 32),
            
            recentLogsAsync.when(
              data: (logs) {
                if (logs.isEmpty) return const SizedBox.shrink();
                return Column(
                  children: [
                    RecentLogsSection(logs: logs),
                    const SizedBox(height: 32),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              ),
              error: (e, st) => const SizedBox.shrink(),
            ),
            
            // Actions
            AppButton(
              label: 'Arsipkan Habit',
              onPressed: _archiveHabit,
              variant: AppButtonVariant.primary,
            ),
            const SizedBox(height: 16),
            AppButton(
              label: 'Hapus Permanen',
              onPressed: _deleteHabit,
              variant: AppButtonVariant.error,
            ),
          ],
        ),
      ),
    );
  }
}
