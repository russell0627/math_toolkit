import 'dart:math' as math;
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/math_utils.dart';
import '../controller/pythagorean_ctrl.dart';
import '../model/pythagorean_model.dart';

class PythagoreanView extends ConsumerStatefulWidget {
  final bool isCompact;
  const PythagoreanView({super.key, this.isCompact = false});

  @override
  ConsumerState<PythagoreanView> createState() => _PythagoreanViewState();
}

class _PythagoreanViewState extends ConsumerState<PythagoreanView> {
  late FocusNode _focusNodeA;
  late FocusNode _focusNodeB;
  late FocusNode _focusNodeC;

  late TextEditingController _controllerA;
  late TextEditingController _controllerB;
  late TextEditingController _controllerC;

  @override
  void initState() {
    super.initState();
    _controllerA = TextEditingController();
    _controllerB = TextEditingController();
    _controllerC = TextEditingController();
    _focusNodeA = FocusNode();
    _focusNodeB = FocusNode();
    _focusNodeC = FocusNode();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    _controllerC.dispose();
    _focusNodeA.dispose();
    _focusNodeB.dispose();
    _focusNodeC.dispose();
    super.dispose();
  }

  void _syncControllers(PythagoreanState state) {
    _updateIfChanged(_controllerA, state.sideA, state.isUserA, _focusNodeA);
    _updateIfChanged(_controllerB, state.sideB, state.isUserB, _focusNodeB);
    _updateIfChanged(_controllerC, state.sideC, state.isUserC, _focusNodeC);
  }

  void _updateIfChanged(TextEditingController controller, double? value, bool isUser, FocusNode focusNode) {
    if (value == null) {
      if (controller.text.isNotEmpty) {
        // Only skip clearing if it's a user field that has focus (prevents erasing partial input like "-")
        if (isUser && focusNode.hasFocus) return;
        controller.text = "";
      }
      return;
    }

    final radicalText = MathUtils.tryFormatAsRadical(value);
    final decimalText = value
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'\.00$'), '')
        .replaceAll(RegExp(r'0$'), '')
        .replaceAll(RegExp(r'\.$'), '');

    final targetText = radicalText ?? decimalText;

    if (isUser) {
      // For input fields, only sync if raw value diverges and we don't have focus
      final currentVal = MathUtils.evaluateExpression(controller.text);
      if (currentVal != null && (currentVal - value).abs() > 1e-9 && !focusNode.hasFocus) {
        controller.text = targetText;
      }
    } else {
      // For output fields, always sync if string differs
      if (controller.text != targetText) {
        controller.text = targetText;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pythagoreanCtrlProvider);
    final ctrl = ref.read(pythagoreanCtrlProvider.notifier);
    final styles = context.textStyles;

    _syncControllers(state);

    return Column(
      children: [
        _buildAlignmentStatus(state, styles),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
            child: Column(
              children: [
                _buildSideUnit(
                  "REQUISITION: LEG ALPHA (A)",
                  _controllerA,
                  _focusNodeA,
                  ctrl.updateSideA,
                  state.isUserA,
                  Colors.greenAccent,
                ),
                const SizedBox(height: 24),
                _buildSideUnit(
                  "REQUISITION: LEG BETA (B)",
                  _controllerB,
                  _focusNodeB,
                  ctrl.updateSideB,
                  state.isUserB,
                  Colors.greenAccent,
                ),
                const SizedBox(height: 24),
                _buildSideUnit(
                  "VERIFICATION: HYPOTENUSE (C)",
                  _controllerC,
                  _focusNodeC,
                  ctrl.updateSideC,
                  state.isUserC,
                  Colors.blueAccent,
                ),
                SizedBox(height: widget.isCompact ? 24 : 40),
                _buildFormulaDisplay(state),
                if (state.estimationRange.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildEstimationDisplay(state),
                ],
              ],
            ),
          ),
        ),
        // Visualization Area at the bottom
        Container(
          height: widget.isCompact ? 120 : 200,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.blueAccent.withValues(alpha: 0.02)],
            ),
          ),
          child: CustomPaint(
            painter: PythagoreanPainter(state),
          ),
        ),
      ],
    );
  }

  Widget _buildAlignmentStatus(PythagoreanState state, dynamic styles) {
    final isValid = state.isValidAlignment;
    final isError = !isValid && state.isFull;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      color: isError ? Colors.redAccent.withValues(alpha: 0.1) : Colors.blueAccent.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isError ? Icons.warning_amber : Icons.verified_user_outlined,
                size: 14,
                color: isError ? Colors.redAccent : Colors.blueAccent,
              ),
              const SizedBox(width: 12),
              Text(
                isError ? "HYPOTENUSE MISMATCH" : (state.isFull ? "ALIGNMENT SECURE" : "AWAITING VECTORS..."),
                style: GoogleFonts.shareTechMono(
                  color: isError ? Colors.redAccent : Colors.blueAccent,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => ref.read(pythagoreanCtrlProvider.notifier).reset(),
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.blueAccent.withValues(alpha: 0.3), size: 16),
            tooltip: "PURGE BUFFER",
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildSideUnit(
    String title,
    TextEditingController controller,
    FocusNode focusNode,
    Function(String) onChanged,
    bool isUser,
    Color accent,
  ) {
    return Container(
      padding: EdgeInsets.all(widget.isCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: widget.isCompact ? 7 : 10),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            style: GoogleFonts.shareTechMono(
              color: isUser ? accent : accent.withValues(alpha: 0.4),
              fontSize: widget.isCompact ? 16 : 20,
              fontStyle: isUser ? FontStyle.normal : FontStyle.italic,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: "0.00",
              hintStyle: GoogleFonts.shareTechMono(color: Colors.white10),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: isUser ? accent.withValues(alpha: 0.3) : Colors.white10),
              ),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accent)),
            ),
            focusNode: focusNode,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaDisplay(PythagoreanState state) {
    final a = state.sideA?.toStringAsFixed(2) ?? "a";
    final b = state.sideB?.toStringAsFixed(2) ?? "b";
    final c = state.sideC?.toStringAsFixed(2) ?? "c";

    return Column(
      children: [
        Text(
          "$a² + $b² = $c²",
          style: GoogleFonts.shareTechMono(
            color: Colors.white12,
            fontSize: widget.isCompact ? 18 : 24,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildEstimationDisplay(PythagoreanState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.05),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            "INTERNAL VALUATION RANGE",
            style: GoogleFonts.shareTechMono(color: Colors.blueAccent.withValues(alpha: 0.5), fontSize: 9),
          ),
          const SizedBox(height: 8),
          Text(
            state.estimationRange,
            style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PythagoreanPainter extends CustomPainter {
  final PythagoreanState state;
  PythagoreanPainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    if (state.sideA == null || state.sideB == null) return;
    final paint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final glowPaint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final double sideA = state.sideA!;
    final double sideB = state.sideB!;
    final double maxVal = math.max(sideA, sideB);
    
    // Scale to fit the bottom area
    final double scale = (math.min(size.width, size.height) * 0.7) / maxVal;
    final h = sideA * scale;
    final w = sideB * scale;
    
    // Center in the provided size
    final center = Offset(size.width / 2, size.height / 2);
    
    final pA = Offset(center.dx - w / 2, center.dy + h / 2);
    final pB = Offset(center.dx + w / 2, center.dy + h / 2);
    final pC = Offset(center.dx - w / 2, center.dy - h / 2);
    
    final path = Path()
      ..moveTo(pA.dx, pA.dy)
      ..lineTo(pB.dx, pB.dy)
      ..lineTo(pC.dx, pC.dy)
      ..close();

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    // Draw little square for right angle
    final squareSize = 10.0;
    final squarePath = Path()
      ..moveTo(pA.dx + squareSize, pA.dy)
      ..lineTo(pA.dx + squareSize, pA.dy - squareSize)
      ..lineTo(pA.dx, pA.dy - squareSize);
    canvas.drawPath(squarePath, paint);

    // Add labels
    final spanA = TextSpan(style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10), text: "a");
    final tpA = TextPainter(text: spanA, textDirection: TextDirection.ltr)..layout();
    tpA.paint(canvas, Offset(pA.dx - 15, center.dy));

    final spanB = TextSpan(style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10), text: "b");
    final tpB = TextPainter(text: spanB, textDirection: TextDirection.ltr)..layout();
    tpB.paint(canvas, Offset(center.dx, pA.dy + 5));

    final spanC = TextSpan(style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontSize: 10), text: "c");
    final tpC = TextPainter(text: spanC, textDirection: TextDirection.ltr)..layout();
    tpC.paint(canvas, Offset(center.dx + 5, center.dy - 10));
  }

  @override
  bool shouldRepaint(covariant PythagoreanPainter oldDelegate) => state != oldDelegate.state;
}
