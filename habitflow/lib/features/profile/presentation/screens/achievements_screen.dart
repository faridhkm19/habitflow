import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../providers/achievement_provider.dart';
import '../widgets/achievement_badge_card.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Pencapaian'),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: achievementsAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Gagal memuat pencapaian',
            style: TextStyle(color: AppColors.error),
          ),
        ),
        data: (achievements) {
          if (achievements.isEmpty) {
            return const Center(child: Text('Belum ada data pencapaian.'));
          }

          final unlockedCount = achievements.where((a) => a.isUnlocked).length;
          final totalCount = achievements.length;
          final progressRatio = totalCount > 0 ? unlockedCount / totalCount : 0.0;

          return CustomScrollView(
            slivers: [
              // Header Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pencapaian Terbuka',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              '$unlockedCount / $totalCount',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progressRatio,
                            minHeight: 8,
                            backgroundColor: AppColors.primaryLight,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Grid Badge
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final achievement = achievements[index];
                      return AchievementBadgeCard(achievement: achievement);
                    },
                    childCount: achievements.length,
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          );
        },
      ),
    );
  }
}
