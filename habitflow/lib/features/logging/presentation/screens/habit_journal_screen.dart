import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../domain/entities/journal_entry_entity.dart';
import '../providers/habit_journal_provider.dart';

class HabitJournalScreen extends ConsumerWidget {
  const HabitJournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedEntries = ref.watch(filteredAndGroupedJournalProvider);
    final entriesAsync = ref.watch(habitJournalProvider);
    final searchQuery = ref.watch(journalSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Check-in'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildSearchBar(context, ref, searchQuery),
          Expanded(
            child: entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty && searchQuery.isEmpty) {
                  return _buildEmptyState(context);
                }

                if (groupedEntries.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada catatan yang sesuai dengan pencarian.',
                    ),
                  );
                }

                final dates = groupedEntries.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final dateEntries = groupedEntries[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 12,
                            top: index == 0 ? 0 : 24,
                          ),
                          child: Text(
                            _formatDate(date),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                        ...dateEntries.map(
                          (entry) => _buildJournalCard(context, entry),
                        ),
                      ],
                    );
                  },
                );
              },
              // Kategori 1: skeleton grup tanggal + 2–3 card catatan
              loading: () => const JournalSkeleton(),
              error: (err, stack) => Center(
                child: Text(
                  'Terjadi kesalahan: $err',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    WidgetRef ref,
    String currentQuery,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: TextField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: currentQuery,
              selection: TextSelection.collapsed(offset: currentQuery.length),
            ),
          ),
          onChanged: (value) =>
              ref.read(journalSearchQueryProvider.notifier).state = value,
          decoration: InputDecoration(
            hintText: 'Cari catatan atau habit...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum ada catatan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Mulai check-in dengan mood atau catatan harian!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context, JournalEntryEntity entry) {
    final habitColor = ColorExtension.fromHex(entry.habitColorHex);
    final habitIcon = getHabitIcon(entry.habitIconName);

    IconData? moodIcon;
    Color? moodColor;

    if (entry.mood == 'good') {
      moodIcon = Icons.sentiment_very_satisfied_rounded;
      moodColor = AppColors.secondary;
    } else if (entry.mood == 'neutral') {
      moodIcon = Icons.sentiment_neutral_rounded;
      moodColor = AppColors.accent1;
    } else if (entry.mood == 'tired') {
      moodIcon = Icons.sentiment_dissatisfied_rounded;
      moodColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: habitColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(habitIcon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.habitName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (moodIcon != null) Icon(moodIcon, color: moodColor, size: 24),
            ],
          ),
          if (entry.note != null && entry.note!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              entry.note!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'HARI INI';
    } else if (dateToCheck == yesterday) {
      return 'KEMARIN';
    } else {
      return DateFormat('d MMMM yyyy', 'id_ID').format(date).toUpperCase();
    }
  }
}
