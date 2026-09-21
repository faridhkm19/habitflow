import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';
import '../../../habits/domain/entities/habit_entity.dart';

/// Card checklist habit untuk home screen
/// Animasi checkbox: scale-bounce (easeOutBack 250ms)
class HabitChecklistItem extends StatefulWidget {
  final HabitEntity habit;
  final bool isCompleted;
  final int streak;
  final VoidCallback onTap;
  final VoidCallback? onCardTap;

  const HabitChecklistItem({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.streak,
    required this.onTap,
    this.onCardTap,
  });

  @override
  State<HabitChecklistItem> createState() => _HabitChecklistItemState();
}

class _HabitChecklistItemState extends State<HabitChecklistItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Scale bounce animation
    _controller.forward(from: 0.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final habitColor = ColorExtension.fromHex(widget.habit.colorHex);
    final isCompleted = widget.isCompleted;

    return GestureDetector(
      onTap: widget.onCardTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ── Ikon habit ─────────────────────────────────────────────────
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  getHabitIcon(widget.habit.iconName),
                  color: habitColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // ── Nama habit & streak ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.habit.name,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.streak > 0) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department_rounded,
                            size: 13, color: isCompleted ? AppColors.warning : AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.streak} hari',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isCompleted ? AppColors.warning : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            // ── Animated Checkbox ──────────────────────────────────────────
            GestureDetector(
              onTap: _handleTap,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_controller.value * 0.15),
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? habitColor : Colors.transparent,
                    border: Border.all(
                      color: habitColor,
                      width: isCompleted ? 0 : 2.5,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 18)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

}
