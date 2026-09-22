import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../shared/widgets/common_widgets.dart';

/// The large circular "service in progress" timer.
///
/// The source of truth is [startedAt] — a server timestamp, set only when the
/// backend actually recorded work starting. The ticking here is purely a
/// display refresh (once a second) so the ring and the clock move smoothly;
/// the elapsed value itself is always `DateTime.now() - startedAt`, recomputed
/// fresh on every tick. A screen rebuild, a background/foreground cycle, or a
/// realtime reconnect all land on the same correct elapsed time, because
/// nothing is accumulated locally.
class ServiceTimerCard extends StatefulWidget {
  const ServiceTimerCard({required this.startedAt, super.key});

  final DateTime startedAt;

  @override
  State<ServiceTimerCard> createState() => _ServiceTimerCardState();
}

class _ServiceTimerCardState extends State<ServiceTimerCard> {
  late Duration _elapsed = DateTime.now().difference(widget.startedAt);
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsed = DateTime.now().difference(widget.startedAt));
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _elapsed.isNegative ? Duration.zero : _elapsed;
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    final seconds = elapsed.inSeconds.remainder(60);
    final label = hours > 0
        ? '${_two(hours)}:${_two(minutes)}:${_two(seconds)}'
        : '${_two(minutes)}:${_two(seconds)}';

    return AppCard(
      child: Column(
        children: [
          SizedBox(
            width: 168,
            height: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(168, 168),
                  // A full sweep every 30 minutes — there is no target
                  // duration to count down to, so the ring simply shows
                  // motion rather than a fabricated "percent done".
                  painter: _TimerRingPainter(
                    progress: (elapsed.inSeconds % 1800) / 1800,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTypography.headlineLarge
                          .copyWith(color: context.ink, fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ]),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text('Service time',
                        style: AppTypography.bodySmall
                            .copyWith(color: context.inkSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}

class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({required this.progress});

  /// 0.0–1.0 around the ring. Wraps continuously — this is a live-activity
  /// indicator, not a countdown to a known end.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 12) / 2;

    final track = Paint()
      ..color = AppColors.surfaceMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
