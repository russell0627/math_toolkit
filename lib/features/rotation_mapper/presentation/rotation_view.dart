import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/rotation_ctrl.dart';
import '../model/rotation_model.dart';
import 'dart:math' as math;

class RotationView extends ConsumerStatefulWidget {
  final bool isCompact;
  const RotationView({super.key, this.isCompact = false});

  @override
  ConsumerState<RotationView> createState() => _RotationViewState();
}

class _RotationViewState extends ConsumerState<RotationView> {
  late TextEditingController _xCtrl;
  late TextEditingController _yCtrl;

  @override
  void initState() {
    super.initState();
    _xCtrl = TextEditingController();
    _yCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _xCtrl.dispose();
    _yCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rotationCtrlProvider);
    final ctrl = ref.read(rotationCtrlProvider.notifier);

    // Sync controllers if not focused
    if (_xCtrl.text != (state.x?.toString() ?? "") && !FocusScope.of(context).hasFocus) {
       _xCtrl.text = state.x?.toString() ?? "";
    }
    if (_yCtrl.text != (state.y?.toString() ?? "") && !FocusScope.of(context).hasFocus) {
       _yCtrl.text = state.y?.toString() ?? "";
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(ctrl),
                const SizedBox(height: 24),
                _buildModificationChart(),
                const SizedBox(height: 24),
                if (state.hasInput) ...[
                  _buildResultsSection(state),
                  const SizedBox(height: 24),
                  _buildVisualizer(state),
                ] else ...[
                  _buildEmptyState(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModificationChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ROTATION TRANSFORM RULES",
            style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildChartRow("90° CCW / 270° CW", "(x, y) → (-y, x)"),
          const Divider(height: 12, color: Colors.white10),
          _buildChartRow("180° CCW / 180° CW", "(x, y) → (-x, -y)"),
          const Divider(height: 12, color: Colors.white10),
          _buildChartRow("270° CCW / 90° CW", "(x, y) → (y, -x)"),
        ],
      ),
    );
  }

  Widget _buildChartRow(String label, String rule) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
        Text(rule, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInputSection(RotationCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ORIGIN COORDINATES",
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 16),
          _buildCoordInput("X", _xCtrl, ctrl.updateX),
          const SizedBox(height: 12),
          _buildCoordInput("Y", _yCtrl, ctrl.updateY),
        ],
      ),
    );
  }

  Widget _buildCoordInput(String label, TextEditingController controller, Function(String) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            label,
            style: GoogleFonts.shareTechMono(color: Colors.white12, fontSize: 12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
            style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              hintText: "0.0",
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

  Widget _buildResultsSection(RotationState state) {
    return Column(
      children: [
        _buildResultCard("90° CCW / 270° CW", state.rot90CCWX!, state.rot90CCWY!, Colors.redAccent),
        const SizedBox(height: 12),
        _buildResultCard("180° CCW / 180° CW", state.rot180X!, state.rot180Y!, Colors.yellowAccent),
        const SizedBox(height: 12),
        _buildResultCard("270° CCW / 90° CW", state.rot270CCWX!, state.rot270CCWY!, Colors.tealAccent),
      ],
    );
  }

  Widget _buildResultCard(String title, double rx, double ry, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.shareTechMono(color: color.withValues(alpha: 0.5), fontSize: 9)),
          Text(
            "(${rx.toStringAsFixed(1)}, ${ry.toStringAsFixed(1)})",
            style: GoogleFonts.shareTechMono(color: color, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizer(RotationState state) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          border: Border.all(color: Colors.white10),
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          painter: RotationPainter(state),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          "WAITING FOR\nVECTOR DATA...",
          textAlign: TextAlign.center,
          style: GoogleFonts.shareTechMono(color: Colors.white.withValues(alpha: 0.05), fontSize: 10, height: 1.5),
        ),
      ),
    );
  }
}

class RotationPainter extends CustomPainter {
  final RotationState state;
  RotationPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 1;

    // Draw Axes
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint..color = Colors.white.withValues(alpha: 0.05));
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint..color = Colors.white.withValues(alpha: 0.05));

    if (state.hasInput) {
      final x = state.x!;
      final y = state.y!;
      
      final radius = math.sqrt(x * x + y * y);
      final maxVal = radius; // Always use radius for scale to fit circles
      final scale = (size.width * 0.4) / (maxVal == 0 ? 1 : maxVal);

      void drawPoint(double px, double py, Color color, String label) {
        final pos = Offset(center.dx + px * scale, center.dy - py * scale);
        canvas.drawCircle(pos, 4, Paint()..color = color);
        
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: GoogleFonts.shareTechMono(color: color.withValues(alpha: 0.5), fontSize: 8),
          ),
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(canvas, pos.translate(6, -12));
      }

      // Draw dashed orbit
      canvas.drawCircle(
        center, 
        radius * scale, 
        Paint()
          ..color = Colors.white.withValues(alpha: 0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
      );

      // Original
      drawPoint(x, y, Colors.white, "ORIGIN");
      // 90 CCW / 270 CW
      drawPoint(state.rot90CCWX!, state.rot90CCWY!, Colors.redAccent, "90° CCW");
      // 180 CCW / 180 CW
      drawPoint(state.rot180X!, state.rot180Y!, Colors.yellowAccent, "180°");
      // 270 CCW / 90 CW
      drawPoint(state.rot270CCWX!, state.rot270CCWY!, Colors.tealAccent, "270° CCW");

      // Draw connecting arcs or straight lines to center
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..strokeWidth = 1;
      
      canvas.drawLine(center, Offset(center.dx + x * scale, center.dy - y * scale), linePaint);
      canvas.drawLine(center, Offset(center.dx + state.rot90CCWX! * scale, center.dy - state.rot90CCWY! * scale), linePaint);
      canvas.drawLine(center, Offset(center.dx + state.rot180X! * scale, center.dy - state.rot180Y! * scale), linePaint);
      canvas.drawLine(center, Offset(center.dx + state.rot270CCWX! * scale, center.dy - state.rot270CCWY! * scale), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant RotationPainter oldDelegate) => state != oldDelegate.state;
}
