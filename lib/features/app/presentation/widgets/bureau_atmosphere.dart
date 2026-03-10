import 'dart:math' as math;
import 'package:flutter/material.dart';

class BureauAtmosphere extends StatefulWidget {
  final Widget child;
  const BureauAtmosphere({super.key, required this.child});

  @override
  State<BureauAtmosphere> createState() => _BureauAtmosphereState();
}

class _BureauAtmosphereState extends State<BureauAtmosphere> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
        return Stack(
          children: [
            // Ambient Gradient Foundation
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Color(0xFF1A1A1A),
                      Color(0xFF0D0D0D),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
            widget.child,
            IgnorePointer(
              child: CustomPaint(
                painter: _AtmospherePainter(
                  seed: _controller.value,
                  intensity: _calculateIntensity(),
                ),
                child: Container(),
              ),
            ),
          ],
        );
      },
    );
  }

  double _calculateIntensity() {
    final hour = DateTime.now().hour;
    if (hour < 6 || hour > 20) return 0.15;
    if (hour < 8 || hour > 18) return 0.10;
    return 0.05;
  }
}

class _AtmospherePainter extends CustomPainter {
  final double seed;
  final double intensity;

  _AtmospherePainter({required this.seed, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final math.Random random = math.Random(42); // Fixed seed for spatial consistency
    final grainRandom = math.Random((seed * 1000).toInt());
    final paint = Paint();

    // 1. Dust Motes (Slow drifting amber particles)
    for (int i = 0; i < 30; i++) {
      final basePosX = random.nextDouble() * size.width;
      final basePosY = random.nextDouble() * size.height;

      // Add subtle drift based on seed
      final driftX = math.sin(seed * 2 * math.pi + i) * 10;
      final driftY = math.cos(seed * 2 * math.pi + i) * 10;

      final opacity = (0.05 + random.nextDouble() * 0.1) * (1 - (seed - 0.5).abs() * 2);
      paint.color = Colors.amberAccent.withValues(alpha: opacity * intensity * 5);

      canvas.drawCircle(Offset(basePosX + driftX, basePosY + driftY), 1.0 + random.nextDouble(), paint);
    }

    // 2. Dynamic Grain
    for (int i = 0; i < 150; i++) {
      final x = grainRandom.nextDouble() * size.width;
      final y = grainRandom.nextDouble() * size.height;
      final opacity = grainRandom.nextDouble() * intensity;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawRect(Rect.fromLTWH(x, y, 1.2, 1.2), paint);
    }
  }

  @override
  bool shouldRepaint(_AtmospherePainter oldDelegate) => true;
}
