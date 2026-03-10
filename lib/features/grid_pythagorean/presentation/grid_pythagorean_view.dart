import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/math_utils.dart';
import '../controller/grid_ctrl.dart';
import '../model/grid_model.dart';

class GridPythagoreanView extends ConsumerStatefulWidget {
  const GridPythagoreanView({super.key});

  @override
  ConsumerState<GridPythagoreanView> createState() => _GridPythagoreanViewState();
}

class _GridPythagoreanViewState extends ConsumerState<GridPythagoreanView> {
  late TextEditingController _x1Ctrl;
  late TextEditingController _y1Ctrl;
  late TextEditingController _x2Ctrl;
  late TextEditingController _y2Ctrl;
  late FocusNode _x1Focus;
  late FocusNode _y1Focus;
  late FocusNode _x2Focus;
  late FocusNode _y2Focus;

  @override
  void initState() {
    super.initState();
    _x1Ctrl = TextEditingController();
    _y1Ctrl = TextEditingController();
    _x2Ctrl = TextEditingController();
    _y2Ctrl = TextEditingController();
    _x1Focus = FocusNode();
    _y1Focus = FocusNode();
    _x2Focus = FocusNode();
    _y2Focus = FocusNode();
  }

  @override
  void dispose() {
    _x1Ctrl.dispose();
    _y1Ctrl.dispose();
    _x2Ctrl.dispose();
    _y2Ctrl.dispose();
    _x1Focus.dispose();
    _y1Focus.dispose();
    _x2Focus.dispose();
    _y2Focus.dispose();
    super.dispose();
  }

  void _syncControllers(GridPythagoreanState state) {
    _updateIfChanged(_x1Ctrl, state.x1, _x1Focus);
    _updateIfChanged(_y1Ctrl, state.y1, _y1Focus);
    _updateIfChanged(_x2Ctrl, state.x2, _x2Focus);
    _updateIfChanged(_y2Ctrl, state.y2, _y2Focus);
  }

  void _updateIfChanged(TextEditingController controller, double? value, FocusNode focusNode) {
    if (value == null) {
      if (controller.text.isNotEmpty && !focusNode.hasFocus) {
        controller.text = "";
      }
      return;
    }

    if (focusNode.hasFocus) return;

    final text = value.toString().replaceAll(RegExp(r'\.0$'), '');
    if (controller.text != text) {
      controller.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gridPythagoreanCtrlProvider);
    final ctrl = ref.read(gridPythagoreanCtrlProvider.notifier);

    _syncControllers(state);

    return Stack(
      children: [
        Positioned.fill(
          child: ClipRect(
            child: IgnorePointer(
              child: CustomPaint(
                painter: GridPainter(state),
              ),
            ),
          ),
        ),
        Column(
          children: [
            _buildStatusBar(state),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildPointAlpha(state, ctrl),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildPointBeta(state, ctrl),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (state.isComplete) ...[
                      _buildDistanceFormula(state),
                      const SizedBox(height: 32),
                      _buildResultsGrid(state),
                    ] else ...[
                      _buildEmptyState(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(GridPythagoreanState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      color: Colors.black.withValues(alpha: 0.9), // Opaque background for status bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_4x4, size: 14, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Text(
                state.isComplete ? "COORDINATES MAPPED" : "AWAITING COORD VECTORS...",
                style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontSize: 10),
              ),
            ],
          ),
          if (state.isComplete)
            Text(
              " d = √Δx² + Δy² ",
              style: GoogleFonts.shareTechMono(color: Colors.blueAccent.withValues(alpha: 0.4), fontSize: 9),
            ),
          IconButton(
            onPressed: () => ref.read(gridPythagoreanCtrlProvider.notifier).purge(),
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.blueAccent.withValues(alpha: 0.3), size: 16),
            tooltip: "PURGE BUFFER",
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceFormula(GridPythagoreanState state) {
    final x1 = state.x1!;
    final y1 = state.y1!;
    final x2 = state.x2!;
    final y2 = state.y2!;
    final dx = x2 - x1;
    final dy = y2 - y1;
    final dx2 = dx * dx;
    final dy2 = dy * dy;
    final sum = dx2 + dy2;

    String fmt(double? v) => v == null ? "?" : v.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');

    return _buildAuditBox(
      "DISTANCE FORMULA DERIVATION",
      [
        _formulaStep("1. FORMULA", "d = √((x₂-x₁)² + (y₂-y₁)²)"),
        const SizedBox(height: 12),
        _formulaStep("2. SUBSTITUTION", "d = √(({${fmt(x2)}}-{${fmt(x1)}})² + ({${fmt(y2)}}-{${fmt(y1)}})²)"),
        const SizedBox(height: 12),
        _formulaStep("3. DELTA (LEGS)", "d = √(${fmt(dx)}² + ${fmt(dy)}²)"),
        const SizedBox(height: 12),
        _formulaStep("4. SQUARED", "d = √(${fmt(dx2)} + ${fmt(dy2)})"),
        const SizedBox(height: 12),
        _formulaStep("5. RADICAND", "d = √${fmt(sum)}"),
      ],
      Colors.orangeAccent,
    );
  }

  Widget _formulaStep(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 8),
        ),
        Text(
          value,
          style: GoogleFonts.shareTechMono(color: Colors.orangeAccent.withValues(alpha: 0.8), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPointAlpha(GridPythagoreanState state, GridPythagoreanCtrl ctrl) {
    return _buildAuditBox(
      "POINT ALPHA (P1)",
      [
        _buildCoordInput("X1", _x1Ctrl, _x1Focus, ctrl.updateX1),
        const SizedBox(height: 12),
        _buildCoordInput("Y1", _y1Ctrl, _y1Focus, ctrl.updateY1),
      ],
      Colors.greenAccent,
    );
  }

  Widget _buildPointBeta(GridPythagoreanState state, GridPythagoreanCtrl ctrl) {
    return _buildAuditBox(
      "POINT BETA (P2)",
      [
        _buildCoordInput("X2", _x2Ctrl, _x2Focus, ctrl.updateX2),
        const SizedBox(height: 12),
        _buildCoordInput("Y2", _y2Ctrl, _y2Focus, ctrl.updateY2),
      ],
      Colors.cyanAccent,
    );
  }

  Widget _buildAuditBox(String title, List<Widget> children, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85), // Increased opacity to block background
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCoordInput(
      String label, TextEditingController controller, FocusNode focusNode, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Text(
            label,
            style: GoogleFonts.shareTechMono(color: Colors.white12, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 16),
            decoration: InputDecoration(
              isDense: true,
              hintText: "0",
              hintStyle: GoogleFonts.shareTechMono(color: Colors.white.withValues(alpha: 0.05)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsGrid(GridPythagoreanState state) {
    final dx = state.dx!;
    final dy = state.dy!;
    final distSq = state.distanceValue!;
    final dist = math.sqrt(distSq);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _resultBox("DELTA X (LEG A)", dx.toStringAsFixed(2), Colors.greenAccent)),
            const SizedBox(width: 16),
            Expanded(child: _resultBox("DELTA Y (LEG B)", dy.toStringAsFixed(2), Colors.cyanAccent)),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85), // Increased opacity to block background
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                "LINEAR DISTANCE (HYPOTENUSE)",
                style: GoogleFonts.shareTechMono(color: Colors.blueAccent.withValues(alpha: 0.6), fontSize: 10),
              ),
              const SizedBox(height: 12),
              Text(
                MathUtils.tryFormatAsRadical(dist) ?? dist.toStringAsFixed(4),
                style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "RADICAND: √$distSq",
                style: GoogleFonts.shareTechMono(color: Colors.blueAccent.withValues(alpha: 0.3), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _resultBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(label, style: GoogleFonts.shareTechMono(color: color.withValues(alpha: 0.5), fontSize: 9)),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.shareTechMono(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          "SYSTEM IDLE:\nINPUT COORDINATES TO MAP VECTORS",
          textAlign: TextAlign.center,
          style: GoogleFonts.shareTechMono(color: Colors.white.withValues(alpha: 0.05), fontSize: 12, height: 1.5),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final GridPythagoreanState state;
  GridPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 60);

    // 1. Draw Subtle Background Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // 2. Draw Axes
    final axesPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axesPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axesPaint);

    if (state.isComplete) {
      final x1 = state.x1!;
      final y1 = state.y1!;
      final x2 = state.x2!;
      final y2 = state.y2!;

      // Scaling logic: Map math units to pixels
      // We want to fit the "triangle" and some margin
      final padding = 100.0;
      final viewWidth = size.width - padding;
      final viewHeight = size.height - padding;

      final maxCoord = math.max(math.max(x1.abs(), x2.abs()), math.max(y1.abs(), y2.abs()));

      // Use a scale that respects the origin (axes) or just fits the triangle
      // Let's try to keep the axes visible if possible, but prioritize the connection.
      // For now, simpler: scale based on max distance from origin
      final scale = math.min(viewWidth / 2, viewHeight / 2) / (maxCoord == 0 ? 1 : maxCoord + 1);

      final p1 = Offset(center.dx + x1 * scale, center.dy - y1 * scale);
      final p2 = Offset(center.dx + x2 * scale, center.dy - y2 * scale);
      final pCorner = Offset(p2.dx, p1.dy);

      // 3. Draw Triangle Legs
      final legPaint = Paint()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      // Leg X (Horizontal)
      canvas.drawLine(p1, pCorner, legPaint..color = Colors.greenAccent.withValues(alpha: 0.4));
      // Leg Y (Vertical)
      canvas.drawLine(pCorner, p2, legPaint..color = Colors.cyanAccent.withValues(alpha: 0.4));
      // Hypotenuse
      canvas.drawLine(
        p1,
        p2,
        legPaint
          ..color = Colors.blueAccent.withValues(alpha: 0.8)
          ..strokeWidth = 3,
      );

      // 4. Draw Points
      canvas.drawCircle(p1, 5, Paint()..color = Colors.greenAccent);
      canvas.drawCircle(p2, 5, Paint()..color = Colors.cyanAccent);

      // 5. Labels
      _drawLabel(canvas, "P1 (${x1.toStringAsFixed(0)}, ${y1.toStringAsFixed(0)})", p1, Colors.greenAccent);
      _drawLabel(canvas, "P2 (${x2.toStringAsFixed(0)}, ${y2.toStringAsFixed(0)})", p2, Colors.cyanAccent);

      // Distances on lines
      _drawMidpointLabel(canvas, "Δx:${(x2 - x1).abs().toStringAsFixed(1)}", p1, pCorner, Colors.greenAccent);
      _drawMidpointLabel(canvas, "Δy:${(y2 - y1).abs().toStringAsFixed(1)}", pCorner, p2, Colors.cyanAccent);
      _drawMidpointLabel(
        canvas,
        "d:${math.sqrt(state.distanceValue!).toStringAsFixed(2)}",
        p1,
        p2,
        Colors.blueAccent,
        isBold: true,
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.shareTechMono(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos.translate(8, -18));
  }

  void _drawMidpointLabel(Canvas canvas, String text, Offset a, Offset b, Color color, {bool isBold = false}) {
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.shareTechMono(
          color: color.withValues(alpha: 0.7),
          fontSize: isBold ? 11 : 9,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, mid.translate(-tp.width / 2, 4));
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => state != oldDelegate.state;
}
