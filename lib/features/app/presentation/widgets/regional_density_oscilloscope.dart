import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RegionalDensityOscilloscope extends StatefulWidget {
  final double latestValue;
  final String label;
  final Color color;

  const RegionalDensityOscilloscope({
    super.key,
    required this.latestValue,
    this.label = "SIGNAL",
    this.color = Colors.amberAccent,
  });

  @override
  State<RegionalDensityOscilloscope> createState() => _RegionalDensityOscilloscopeState();
}

class _RegionalDensityOscilloscopeState extends State<RegionalDensityOscilloscope> {
  final List<double> _history = List.filled(100, 0.0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _history.removeAt(0);
        _history.add(widget.latestValue);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: widget.color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.color.withOpacity(0.5),
                  fontSize: 7,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                widget.latestValue.toStringAsFixed(1),
                style: TextStyle(
                  color: widget.color.withOpacity(0.8),
                  fontSize: 7,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: CustomPaint(
              painter: _OscilloscopePainter(
                history: _history,
                color: widget.color,
              ),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _OscilloscopePainter extends CustomPainter {
  final List<double> history;
  final Color color;

  _OscilloscopePainter({required this.history, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = size.width / (history.length - 1);

    // Auto-scale vertical based on historical max in current window
    double maxInHistory = history.reduce(math.max);
    if (maxInHistory < 1.0) maxInHistory = 1.0;

    for (int i = 0; i < history.length; i++) {
      final x = i * step;
      final normalizedY = 1.0 - (history[i] / maxInHistory);
      final y = normalizedY * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Phosphor glow effect
    canvas.drawPath(
      path,
      paint
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0)
        ..strokeWidth = 2.0,
    );
    canvas.drawPath(
      path,
      paint
        ..maskFilter = null
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant _OscilloscopePainter oldDelegate) => true;
}
