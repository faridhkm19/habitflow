import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';

class HabitsListScreen extends ConsumerStatefulWidget {
  const HabitsListScreen({super.key});

  @override
  ConsumerState<HabitsListScreen> createState() => _HabitsListScreenState();
}

class _HabitsListScreenState extends ConsumerState<HabitsListScreen> {
  String _selectedCategory = 'all';

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'health', 'label': 'Kesehatan'},
    {'id': 'learning', 'label': 'Belajar'},
    {'id': 'mindfulness', 'label': 'Mindful'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'social', 'label': 'Sosial'},
    {'id': 'custom', 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);

    final bool showFab = habitsAsync.maybeWhen(
      data: (habits) {
        return habits.any((habit) {
          final matchesCategory = _selectedCategory == 'all' || habit.category == _selectedCategory;
          return matchesCategory && !habit.isArchived;
        });
      },
      orElse: () => false,
    );


    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Daftar Habit', style: AppTextStyles.h1),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category['label']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category['id']!;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Habit List
          Expanded(
            child: habitsAsync.when(
              data: (habits) {
                // Filter habits based on selected category and exclude archived
                final filteredHabits = habits.where((habit) {
                  final matchesCategory = _selectedCategory == 'all' || habit.category == _selectedCategory;
                  return matchesCategory && !habit.isArchived;
                }).toList();

                if (filteredHabits.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.track_changes_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Belum Ada Habit',
                            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Yuk, mulai bangun kebiasaan positif pertamamu di kategori ini!',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          AppButton(
                            label: 'Buat Habit Baru',
                            onPressed: () => context.push(AppRoutes.addHabit),
                            isFullWidth: false,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: filteredHabits.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    return HabitCard(
                      habit: habit,
                      showCategory: _selectedCategory == 'all',
                      onTap: () {
                        context.push('${AppRoutes.habits}/${habit.id}', extra: habit);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Gagal memuat daftar habit.', style: AppTextStyles.bodyMedium),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: FloatingActionButton(
                onPressed: () {
                  context.push(AppRoutes.addHabit);
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: AppColors.textOnPrimary),
              ),
            )
          : null,
    );
  }
}
