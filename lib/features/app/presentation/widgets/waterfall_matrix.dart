import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterfallMatrix extends StatefulWidget {
  final List<int> bytes;
  final List<bool> matches;
  final double scrollSpeed;
  final Color baseColor;
  final Color highlightColor;

  const WaterfallMatrix({
    super.key,
    required this.bytes,
    required this.matches,
    this.scrollSpeed = 2.0,
    this.baseColor = Colors.greenAccent,
    this.highlightColor = Colors.pinkAccent,
  });

  @override
  State<WaterfallMatrix> createState() => _WaterfallMatrixState();
}

class _WaterfallMatrixState extends State<WaterfallMatrix> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_WaterfallColumn> _columns = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateColumns(double width) {
    const double colWidth = 30.0;
    final int count = (width / colWidth).floor();

    if (_columns.length != count) {
      _columns.clear();
      for (int i = 0; i < count; i++) {
        _columns.add(
          _WaterfallColumn(
            x: i * colWidth,
            offset: _random.nextDouble() * 1000,
            speed: 1.0 + _random.nextDouble() * 2.0,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _updateColumns(constraints.maxWidth);
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: _WaterfallPainter(
                columns: _columns,
                bytes: widget.bytes,
                matches: widget.matches,
                baseColor: widget.baseColor,
                highlightColor: widget.highlightColor,
                time: _controller.value,
              ),
            );
          },
        );
      },
    );
  }
}

class _WaterfallColumn {
  final double x;
  final double offset;
  final double speed;

  _WaterfallColumn({required this.x, required this.offset, required this.speed});
}

class _WaterfallPainter extends CustomPainter {
  final List<_WaterfallColumn> columns;
  final List<int> bytes;
  final List<bool> matches;
  final Color baseColor;
  final Color highlightColor;
  final double time;

  _WaterfallPainter({
    required this.columns,
    required this.bytes,
    required this.matches,
    required this.baseColor,
    required this.highlightColor,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bytes.isEmpty) return;

    final textStyle = TextStyle(
      color: baseColor,
      fontSize: 12,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    final highlightStyle = textStyle.copyWith(
      color: highlightColor,
      shadows: [
        Shadow(color: highlightColor.withOpacity(0.8), blurRadius: 10),
      ],
    );

    for (var col in columns) {
      final double columnYStart = (time * 100 * col.speed + col.offset) % size.height;
      int byteIndex = (col.x.toInt() * 7 + col.speed.toInt() * 13) % bytes.length;

      for (double y = -20; y < size.height; y += 18) {
        final double drawY = (columnYStart + y) % size.height;

        // Fade based on vertical position (simulating a trail)
        final double opacity = (1.0 - (drawY / size.height)).clamp(0.1, 0.8);

        final byte = bytes[byteIndex % bytes.length];
        final isMatch = matches[byteIndex % matches.length];
        final char = byte.toRadixString(16).padLeft(2, '0').toUpperCase();

        final span = TextSpan(
          text: char,
          style: (isMatch ? highlightStyle : textStyle).copyWith(
            color: (isMatch ? highlightColor : baseColor).withOpacity(opacity),
          ),
        );

        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, Offset(col.x, drawY));

        byteIndex++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WaterfallPainter oldDelegate) => true;
}
