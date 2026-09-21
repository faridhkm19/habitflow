import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Progress ring harian — CustomPainter dengan animasi easeInOutCubic
class DailyProgressRing extends StatefulWidget {
  final double progress; // 0.0 – 1.0
  final int completedCount;
  final int totalCount;

  const DailyProgressRing({
    super.key,
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  State<DailyProgressRing> createState() => _DailyProgressRingState();
}

class _DailyProgressRingState extends State<DailyProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DailyProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      final currentValue = _animation.value;
      _animation = Tween<double>(
        begin: currentValue,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final isComplete = widget.progress >= 1.0 && widget.totalCount > 0;
        return Column(
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _RingPainter(
                  progress: _animation.value,
                  ringColor: isComplete ? AppColors.secondaryDark : AppColors.primary,
                  trackColor: AppColors.neutralMissed,
                  strokeWidth: 14.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(_animation.value * 100).round()}%',
                        style: AppTextStyles.numberLarge.copyWith(
                          color: isComplete ? AppColors.secondaryDark : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isComplete 
                  ? 'Semua ${widget.totalCount} habit selesai!' 
                  : '${widget.completedCount} dari ${widget.totalCount} habit selesai',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isComplete ? AppColors.secondaryDark : AppColors.textSecondary,
                fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;
  final Color trackColor;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.ringColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Track (background ring)
    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      // Progress arc — mulai dari atas (-π/2), searah jarum jam
      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.ringColor != ringColor;
}
