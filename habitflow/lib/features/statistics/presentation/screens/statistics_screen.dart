import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../providers/statistics_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../widgets/heatmap_chart.dart';
import '../widgets/weekly_radial_chart.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  static const List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'health', 'label': 'Kesehatan'},
    {'id': 'learning', 'label': 'Belajar'},
    {'id': 'mindfulness', 'label': 'Mindful'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'social', 'label': 'Sosial'},
    {'id': 'custom', 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final selectedHabitId = ref.watch(selectedStatisticsHabitIdProvider);
    final statsAsync = ref.watch(statisticsDataProvider);
    final selectedCategory = ref.watch(selectedStatisticsCategoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Statistics', style: AppTextStyles.h1),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: habitsAsync.when(
        // Kategori 1: skeleton chart area + heatmap grid
        loading: () => const StatisticsSkeleton(),
        error: (err, stack) =>
            Center(child: Text('Error loading habits: $err')),
        data: (habits) {
          final activeHabits = habits.where((h) => !h.isArchived).toList();

          if (activeHabits.isEmpty) {
            return const Center(child: Text("Belum ada habit aktif."));
          }

          final filteredHabits = activeHabits.where((habit) {
            return selectedCategory == 'all' ||
                habit.category == selectedCategory;
          }).toList();

          String? currentId = selectedHabitId;
          if (filteredHabits.isNotEmpty) {
            final isCurrentInFiltered = filteredHabits.any(
              (h) => h.id == currentId,
            );
            if (!isCurrentInFiltered) {
              currentId = filteredHabits.first.id;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(selectedStatisticsHabitIdProvider.notifier).state =
                    currentId;
              });
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = selectedCategory == category['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: AppColors.primary.withValues(alpha: 0.08),
                          focusColor: AppColors.primary.withValues(alpha: 0.08),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: FilterChip(
                          label: Text(
                            category['label']!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          selected: isSelected,
                          showCheckmark: false,
                          onSelected: (_) {
                            ref
                                    .read(
                                      selectedStatisticsCategoryProvider
                                          .notifier,
                                    )
                                    .state =
                                category['id']!;
                          },
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          surfaceTintColor: Colors.transparent,
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Main Content
              Expanded(
                child: filteredHabits.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.track_changes_rounded,
                                  size: 64,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Belum Ada Habit',
                                style: AppTextStyles.h2.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Yuk, mulai bangun kebiasaan positif pertamamu di kategori ini!',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              AppButton(
                                label: 'Buat Habit Baru',
                                onPressed: () =>
                                    context.push(AppRoutes.addHabit),
                                isFullWidth: false,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Builder(
                        builder: (context) {
                          final selectedHabit = filteredHabits.firstWhere(
                            (h) => h.id == currentId,
                          );
                          final habitColor = ColorExtension.fromHex(
                            selectedHabit.colorHex,
                          );
                          final habitBgColor = getLighterColor(
                            habitColor,
                            0.15,
                          );

                          return RefreshIndicator(
                            onRefresh: () async {
                              ref.invalidate(statisticsDataProvider);
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                MediaQuery.paddingOf(context).bottom +
                                    AppSpacing.listBottomPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Dropdown Selector
                                  InkWell(
                                    onTap: () {
                                      _showHabitSelector(
                                        context,
                                        filteredHabits,
                                        currentId!,
                                        ref,
                                      );
                                    },
                                    splashColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.12),
                                    highlightColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(5),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: habitBgColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              getHabitIcon(
                                                selectedHabit.iconName,
                                              ),
                                              color: habitColor,
                                              size: 20,
                                            ),
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
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Content
                                  statsAsync.when(
                                    // Kategori 1: skeleton chart area + heatmap grid
                                    loading: () => const StatisticsSkeleton(),
                                    error: (err, stack) => Center(
                                      child: Text('Error loading stats: $err'),
                                    ),
                                    data: (stats) {
                                      if (stats == null)
                                        return const SizedBox();

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Minggu Ini",
                                            style: AppTextStyles.h2,
                                          ),
                                          const SizedBox(height: 16),
                                          AppCard(
                                            padding: const EdgeInsets.all(16),
                                            child: WeeklyRadialChart(
                                              heatmapData: stats.annualHeatmap,
                                              activeColor: habitColor,
                                            ),
                                          ),

                                          const SizedBox(height: 32),

                                          Text(
                                            "Riwayat Setahun",
                                            style: AppTextStyles.h2,
                                          ),
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
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showHabitSelector(
    BuildContext context,
    List<HabitEntity> habits,
    String currentId,
    WidgetRef ref,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 24,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
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
                      icon: Icon(
                        Icons.close_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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
                          ref
                              .read(selectedStatisticsHabitIdProvider.notifier)
                              .state = habit
                              .id;
                          Navigator.pop(context);
                        },
                        splashColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                        highlightColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.outlineVariant,
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
                                child: Icon(
                                  getHabitIcon(habit.iconName),
                                  color: itemColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  habit.name,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: isSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
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
