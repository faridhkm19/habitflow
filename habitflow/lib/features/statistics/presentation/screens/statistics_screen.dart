import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../providers/statistics_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../widgets/heatmap_chart.dart';
import '../widgets/weekly_radial_chart.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final selectedHabitId = ref.watch(selectedStatisticsHabitIdProvider);
    final statsAsync = ref.watch(statisticsDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Statistics', style: AppTextStyles.h1),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error loading habits: $err')),
        data: (habits) {
          if (habits.isEmpty) {
            return const Center(child: Text("Belum ada habit."));
          }
          
          final selectedHabit = habits.firstWhere((h) => h.id == (selectedHabitId ?? habits.first.id));
          final habitColor = ColorExtension.fromHex(selectedHabit.colorHex);
          final habitBgColor = getLighterColor(habitColor, 0.15);
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(statisticsDataProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Selector (Button that opens bottom sheet)
                  InkWell(
                    onTap: () {
                      _showHabitSelector(context, habits, selectedHabitId ?? habits.first.id, ref);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: habitBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(getHabitIcon(selectedHabit.iconName), color: habitColor, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedHabit.name,
                              style: AppTextStyles.h3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Content
                  statsAsync.when(
                    loading: () => const Center(child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: LoadingIndicator(),
                    )),
                    error: (err, stack) => Center(child: Text('Error loading stats: $err')),
                    data: (stats) {
                      if (stats == null) return const SizedBox();
                      
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 600) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Minggu Ini", style: AppTextStyles.h2),
                                      const SizedBox(height: 16),
                                      AppCard(
                                        padding: const EdgeInsets.all(16),
                                        child: WeeklyRadialChart(
                                          heatmapData: stats.annualHeatmap,
                                          activeColor: habitColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Riwayat Setahun", style: AppTextStyles.h2),
                                      const SizedBox(height: 16),
                                      AppCard(
                                        padding: const EdgeInsets.all(16),
                                        child: HeatmapChart(
                                          heatmapData: stats.annualHeatmap,
                                          activeColor: habitColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Minggu Ini", style: AppTextStyles.h2),
                              const SizedBox(height: 16),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                child: WeeklyRadialChart(
                                  heatmapData: stats.annualHeatmap,
                                  activeColor: habitColor,
                                ),
                              ),
                              
                              const SizedBox(height: 32),
                              
                              Text("Riwayat Setahun", style: AppTextStyles.h2),
                              const SizedBox(height: 16),
                              AppCard(
                                padding: const EdgeInsets.all(16),
                                child: HeatmapChart(
                                  heatmapData: stats.annualHeatmap,
                                  activeColor: habitColor,
                                ),
                              ),
                            ],
                          );
                        }
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _showHabitSelector(BuildContext context, List<HabitEntity> habits, String currentId, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pilih Habit', style: AppTextStyles.h2),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];
                    final isSelected = habit.id == currentId;
                    
                    final itemColor = ColorExtension.fromHex(habit.colorHex);
                    final itemBgColor = getLighterColor(itemColor, 0.15);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          ref.read(selectedStatisticsHabitIdProvider.notifier).state = habit.id;
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: itemBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(getHabitIcon(habit.iconName), color: itemColor, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  habit.name,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
