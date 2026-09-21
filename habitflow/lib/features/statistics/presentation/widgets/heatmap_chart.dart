import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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
    // We want to show 52 weeks.
    const int cols = 52;
    const int rows = 7;
    final today = DateTime.now();
    final todayWeekday = today.weekday; // 1 = Mon, 7 = Sun
    
    // We want the last column to end on today.
    // So the grid is essentially built backwards from today.
    // Date of a cell at (col, row):
    // Let daysAgo = ((cols - 1 - col) * 7) + (todayWeekday - (row + 1));
    // If daysAgo < 0, it means it's a future day in the current week (should be invisible).

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // Start scrolled to the right (most recent)
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels (Semua hari agar user tidak bingung)
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var day in ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'])
                      Container(
                        height: 18, // 14px box + 4px padding
                        alignment: Alignment.centerRight,
                        child: Text(
                          day,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                            height: 1.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // The Grid
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month labels could go here, but for simplicity we'll just put some space
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(cols, (colIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Column(
                          children: List.generate(rows, (rowIndex) {
                            int daysAgo = ((cols - 1 - colIndex) * 7) + (todayWeekday - (rowIndex + 1));
                            
                            if (daysAgo < 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: SizedBox(width: 14, height: 14),
                              );
                            }
                            
                            final dateRaw = today.subtract(Duration(days: daysAgo));
                            final date = DateTime(dateRaw.year, dateRaw.month, dateRaw.day);
                            
                            // Find status in heatmapData
                            bool? status;
                            for (var key in heatmapData.keys) {
                              if (app_date_utils.isSameDate(key, date)) {
                                status = heatmapData[key];
                                break;
                              }
                            }
                            
                            Color cellColor;
                            if (status == true) {
                              cellColor = activeColor;
                            } else if (status == false) {
                              cellColor = const Color(0xFFD8D5CE); // Neutral Missed
                            } else {
                              cellColor = AppColors.border; // Not scheduled
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: BorderRadius.circular(4), // radius.sm
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
