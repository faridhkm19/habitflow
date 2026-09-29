import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../logging/domain/entities/habit_log_entity.dart';
import '../../../../core/widgets/app_card.dart';

class RecentLogsSection extends StatelessWidget {
  final List<HabitLogEntity> logs;
  final String colorHex;

  const RecentLogsSection({
    super.key,
    required this.logs,
    required this.colorHex,
  });

  Color _getMoodLightColor(String? mood) {
    if (mood == 'good') return AppColors.secondaryLight;
    if (mood == 'neutral') return AppColors.accent1Light;
    if (mood == 'tired') return AppColors.neutralMissed.withValues(alpha: 0.2);
    return Colors.transparent;
  }

  String _getMoodEmoji(String? mood) {
    if (mood == 'good') return '😊';
    if (mood == 'neutral') return '😐';
    if (mood == 'tired') return '😔';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Ambil maksimal 7 hari terakhir dari daftar log
    final recentLogs = logs.take(7).toList();
    final habitColor = ColorExtension.fromHex(colorHex);

    if (recentLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Terbaru', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: recentLogs.map((log) {
              final isLast = log == recentLogs.last;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Tanggal
                        SizedBox(
                          width: 60,
                          child: Text(
                            DateFormat('dd MMM').format(log.logDate),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Status Complete
                        Icon(
                          log.isCompleted ? Icons.check_circle : Icons.cancel,
                          color: log.isCompleted
                              ? habitColor
                              : AppColors.neutralMissed,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        // Mood
                        SizedBox(
                          width: 40,
                          child: log.mood != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getMoodLightColor(log.mood),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _getMoodEmoji(log.mood),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 16),
                        // Note
                        Expanded(
                          child: Text(
                            log.note ?? '-',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: log.note != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(color: AppColors.border, height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
