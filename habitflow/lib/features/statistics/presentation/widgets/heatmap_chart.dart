import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart' as app_date_utils;

class HeatmapChart extends StatelessWidget {
  final Map<DateTime, bool?> heatmapData;
  final Color activeColor;

  const HeatmapChart({
    super.key,
    required this.heatmapData,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    const int rows = 7; // Mon–Sun
    const double cellSize = 14.0;
    const double cellGap = 4.0;
    const double colWidth = cellSize + cellGap; // 18px per column

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // ── Grid boundaries ────────────────────────────────────────────────────
    // Start: Monday on or before Jan 1 of current year.
    // This column may have invisible cells above Jan 1 (like GitHub).
    final jan1 = DateTime(today.year, 1, 1);
    final gridStart = jan1.subtract(Duration(days: jan1.weekday - 1));

    // End: Monday of the week containing today.
    // Only show up to today — no future cells rendered.
    final thisWeekMonday = today.subtract(Duration(days: today.weekday - 1));

    // Total columns = weeks from gridStart to (and including) current week
    final cols = thisWeekMonday.difference(gridStart).inDays ~/ 7 + 1;

    // ── Month labels ───────────────────────────────────────────────────────
    // Place label at the first column whose Monday falls in a new month.
    // We skip the very first label if it's before Jan 1 (won't happen here
    // since gridStart's Monday can at most be Dec 28 of prev year for Jan 1
    // falling on a Sunday — in that case col 0 contains Dec 28–Jan 3, so the
    // month label for Jan goes on col 1 when Jan 1 falls on it).
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    final List<({String label, double offset})> monthLabels = [];
    int? lastLabeledMonth;

    for (int c = 0; c < cols; c++) {
      final colMonday = gridStart.add(Duration(days: c * 7));
      // Find which month this column "belongs to":
      // use the first visible day in this column (max of colMonday and Jan 1).
      final firstVisible = colMonday.isBefore(jan1) ? jan1 : colMonday;

      if (lastLabeledMonth == null || firstVisible.month != lastLabeledMonth) {
        // Only label months within the current year
        if (firstVisible.year == today.year) {
          lastLabeledMonth = firstVisible.month;
          monthLabels.add((
            label: monthNames[firstVisible.month],
            offset: c * colWidth,
          ));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Y-axis day labels ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final day in [
                      'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'
                    ])
                      SizedBox(
                        height: colWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            day,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 10,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Month labels + Grid ───────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month label row — GitHub style
                  SizedBox(
                    height: 20,
                    width: cols * colWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (final m in monthLabels)
                          Positioned(
                            left: m.offset,
                            top: 4,
                            child: Text(
                              m.label,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                height: 1.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Heatmap grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(cols, (colIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(right: cellGap),
                        child: Column(
                          children: List.generate(rows, (rowIndex) {
                            final date = gridStart.add(
                              Duration(days: colIndex * 7 + rowIndex),
                            );

                            // Invisible: before Jan 1 (alignment padding) or after today
                            final beforeYear = date.isBefore(jan1);
                            final afterToday = date.isAfter(today);

                            if (beforeYear || afterToday) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: cellGap),
                                child: SizedBox(width: cellSize, height: cellSize),
                              );
                            }

                            // Look up completion status
                            bool? status;
                            for (final key in heatmapData.keys) {
                              if (app_date_utils.isSameDate(key, date)) {
                                status = heatmapData[key];
                                break;
                              }
                            }

                            final Color cellColor;
                            if (status == true) {
                              cellColor = activeColor;
                            } else if (status == false) {
                              cellColor = Theme.of(context).colorScheme.surfaceContainerHighest; // neutralMissed
                            } else {
                              cellColor = Theme.of(context).colorScheme.outlineVariant; // not scheduled / no data
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: cellGap),
                              child: Container(
                                width: cellSize,
                                height: cellSize,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
