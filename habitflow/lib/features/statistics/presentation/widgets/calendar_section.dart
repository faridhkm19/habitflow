import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../../presentation/providers/calendar_view_provider.dart';

/// Widget kalender bulanan yang dapat diembed langsung di dalam screen lain.
/// Warna tanggal selesai menggunakan colorHex milik habit agar konsisten dengan
/// warna ikon di seluruh halaman.
class CalendarSection extends ConsumerWidget {
  final HabitEntity habit;

  const CalendarSection({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarViewProvider(habit));
    final notifier = ref.read(calendarViewProvider(habit).notifier);

    // Warna khas habit ini (dari colorHex), digunakan untuk tanggal Selesai
    final habitColor = ColorExtension.fromHex(habit.colorHex);

    // Calculate days in month
    final daysInMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month + 1,
      0,
    ).day;
    final firstDayOfMonth = DateTime(
      state.currentMonth.year,
      state.currentMonth.month,
      1,
    );
    final offset =
        firstDayOfMonth.weekday - 1; // weekday 1(Mon)..7(Sun) → offset 0..6
    final today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header Navigasi Bulan ─────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => notifier.prevMonth(),
                iconSize: 20,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              constraints: const BoxConstraints(minWidth: 200),
              child: Text(
                DateFormat('MMMM yyyy', 'id_ID').format(state.currentMonth),
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () => notifier.nextMonth(),
                iconSize: 20,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Nama Hari ─────────────────────────────────────────────────────────
        Row(
          children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),

        // ── Grid Kalender ─────────────────────────────────────────────────────
        // Kategori 1: skeleton grid kalender 7×5 saat ganti bulan
        if (state.isLoading)
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
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
          )
        else
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: offset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox.shrink();

              final day = index - offset + 1;
              final date = DateTime(
                state.currentMonth.year,
                state.currentMonth.month,
                day,
              );
              final isToday =
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;
              final isFuture = date.isAfter(today) && !isToday;
              final isBeforeCreation = date.isBefore(
                DateTime(
                  habit.createdAt.year,
                  habit.createdAt.month,
                  habit.createdAt.day,
                ),
              );

              final isScheduled = isScheduledForToday(habit, date);
              final log = state.logs
                  .where(
                    (l) =>
                        l.logDate.year == date.year &&
                        l.logDate.month == date.month &&
                        l.logDate.day == date.day,
                  )
                  .firstOrNull;
              final isCompleted = log != null && log.isCompleted;

              Color cellColor;
              Color textColor;

              if (isBeforeCreation || isFuture) {
                cellColor = Colors.transparent;
                textColor = Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.4);
              } else if (isCompleted) {
                // Gunakan colorHex habit — unik per habit, konsisten dengan ikon
                cellColor = habitColor;
                textColor = Theme.of(context).colorScheme.onSurface;
              } else if (!isScheduled) {
                cellColor = Theme.of(
                  context,
                ).colorScheme.outlineVariant; // tidak terjadwal
                textColor = Theme.of(context).colorScheme.onSurfaceVariant;
              } else {
                cellColor = Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest; // terjadwal tapi terlewat
                textColor = Theme.of(context).colorScheme.onSurfaceVariant;
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(8), // radius.sm
                  border: isToday
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '$day',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textColor,
                        fontWeight: isToday || isCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isToday && !isCompleted)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 8),

        // ── Legenda ───────────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: habitColor, label: 'Selesai'),
            const SizedBox(width: 24),
            _LegendDot(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              label: 'Terlewat',
            ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
