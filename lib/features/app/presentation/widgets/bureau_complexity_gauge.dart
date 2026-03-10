import 'dart:math' as math;
import 'package:flutter/material.dart';

class BureauComplexityGauge extends StatefulWidget {
  final double complexity; // 0.0 to 1.0
  final double size;

  const BureauComplexityGauge({
    super.key,
    required this.complexity,
    this.size = 40,
  });

  @override
  State<BureauComplexityGauge> createState() => _BureauComplexityGaugeState();
}

class _BureauComplexityGaugeState extends State<BureauComplexityGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: widget.complexity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(BureauComplexityGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.complexity != oldWidget.complexity) {
      _animation =
          Tween<double>(
            begin: _animation.value,
            end: widget.complexity,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
          );
      _controller.forward(from: 0);
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
      animation: _controller,
      builder: (context, child) {
        // Apply jitter if complexity is high
        double jitter = 0.0;
        if (widget.complexity > 0.8) {
          jitter = (_random.nextDouble() - 0.5) * 0.05 * (widget.complexity - 0.7);
        }

        return CustomPaint(
          size: Size(widget.size, widget.size * 0.6),
          painter: _GaugePainter(
            value: (_animation.value + jitter).clamp(0.0, 1.0),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;

  _GaugePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Background Arc
    paint.color = Colors.white10;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Ticks
    for (int i = 0; i <= 10; i++) {
      final angle = math.pi + (i / 10) * math.pi;
      final isRedZone = i >= 8;
      paint.color = isRedZone ? Colors.redAccent.withValues(alpha: 0.3) : Colors.amberAccent.withValues(alpha: 0.2);
      paint.strokeWidth = i % 5 == 0 ? 1.5 : 0.5;

      final start = Offset(
        center.dx + (radius - 4) * math.cos(angle),
        center.dy + (radius - 4) * math.sin(angle),
      );
      final end = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }

    // Needle
    final needleAngle = math.pi + value * math.pi;
    final needlePaint = Paint()
      ..color = value > 0.8 ? Colors.redAccent : Colors.amberAccent
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + (radius - 2) * math.cos(needleAngle),
      center.dy + (radius - 2) * math.sin(needleAngle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Needle pivot
    final pivotPaint = Paint()..color = Colors.black;
    canvas.drawCircle(center, 2, pivotPaint);
    pivotPaint.color = needlePaint.color.withValues(alpha: 0.5);
    canvas.drawCircle(center, 1, pivotPaint);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) => oldDelegate.value != value;
}
