import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/screen_utils.dart';
import '../controller/efficiency_ctrl.dart';
import '../model/efficiency_model.dart';

class EfficiencyView extends ConsumerStatefulWidget {
  final bool isCompact;
  const EfficiencyView({super.key, this.isCompact = false});

  @override
  ConsumerState<EfficiencyView> createState() => _EfficiencyViewState();
}

class _EfficiencyViewState extends ConsumerState<EfficiencyView> {
  final TextEditingController _winController = TextEditingController();
  final TextEditingController _woutController = TextEditingController();

  final FocusNode _winFocus = FocusNode();
  final FocusNode _woutFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _syncTextControllers();
  }

  void _syncTextControllers() {
    final state = ref.read(efficiencyCtrlProvider);
    _winController.text = state.inputWorkInput;
    _woutController.text = state.inputWorkOutput;
  }

  @override
  void dispose() {
    _winController.dispose();
    _woutController.dispose();
    _winFocus.dispose();
    _woutFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(efficiencyCtrlProvider);
    final ctrl = ref.read(efficiencyCtrlProvider.notifier);

    // Sync controllers if state changes externally and fields don't have focus
    if (!_winFocus.hasFocus && _winController.text != state.inputWorkInput) {
      _winController.text = state.inputWorkInput;
    }
    if (!_woutFocus.hasFocus && _woutController.text != state.inputWorkOutput) {
      _woutController.text = state.inputWorkOutput;
    }

    return Column(
      children: [
        _buildStatusBar(state),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(widget.isCompact ? xxl / 2 : xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(state, ctrl),
                if (state.errorMessage != null) ...[
                  boxXL,
                  _buildErrorSection(state.errorMessage!),
                ],
                if (state.hasResult) ...[
                  boxXXL,
                  _buildResultsSection(state),
                  boxXXL,
                  _buildVisualizationSection(state),
                  boxXXL,
                  _buildWorkSection(state),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(EfficiencyState state) {
    final hasResult = state.hasResult;
    final isError = state.errorMessage != null;

    Color color = Colors.tealAccent;
    String text = "AWAITING INGESTION PARAMETERS...";
    IconData icon = Icons.hourglass_empty;

    if (isError) {
      color = Colors.redAccent;
      text = "PARAMETER ANOMALY DETECTED";
      icon = Icons.warning_amber_rounded;
    } else if (hasResult) {
      color = Colors.tealAccent;
      text = "THERMODYNAMIC COMPILATION COMPLETED";
      icon = Icons.verified_user_outlined;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: color.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.shareTechMono(color: color, fontSize: 10, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(EfficiencyState state, EfficiencyCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WORK PARAMETER INGESTION",
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
          ),
          boxXL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _winController,
                  focusNode: _winFocus,
                  label: "Work Input (Wᵢ\u2093)",
                  suffix: "J",
                  onChanged: ctrl.updateWorkInput,
                ),
              ),
              boxXL,
              Expanded(
                child: _buildTextField(
                  controller: _woutController,
                  focusNode: _woutFocus,
                  label: "Work Output (W_out)",
                  suffix: "J",
                  onChanged: ctrl.updateWorkOutput,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String suffix,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: GoogleFonts.shareTechMono(color: Colors.tealAccent, fontSize: 18),
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        isDense: true,
        labelText: label.toUpperCase(),
        labelStyle: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
        suffixText: suffix,
        suffixStyle: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildErrorSection(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.05),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "ERROR: $error",
        style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }

  Widget _buildResultsSection(EfficiencyState state) {
    final effStr = state.efficiency?.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '') ?? "---";
    final lossStr = state.loss?.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '') ?? "---";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.tealAccent.withValues(alpha: 0.02),
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            "COMPILED EFFICIENCY SOLUTIONS",
            style: GoogleFonts.shareTechMono(color: Colors.tealAccent.withValues(alpha: 0.3), fontSize: 10),
          ),
          boxXL,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetricCard("ENERGY EFFICIENCY (\u03b7)", "$effStr%", Colors.tealAccent),
              _buildMetricCard("DISSIPATED LOSS (L)", "$lossStr J", Colors.orangeAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 9),
        ),
        boxS,
        Text(
          value,
          style: GoogleFonts.shareTechMono(color: color, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildVisualizationSection(EfficiencyState state) {
    final win = state.workInput ?? 1.0;
    final wout = state.workOutput ?? 0.0;
    final loss = state.loss ?? 1.0;
    final eff = state.efficiency ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "THERMODYNAMIC ENERGY FLOW DIAGRAM",
          style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
        ),
        boxM,
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRect(
            child: CustomPaint(
              painter: EnergyFlowPainter(
                workInput: win,
                workOutput: wout,
                loss: loss,
                efficiency: eff,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkSection(EfficiencyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CALCULATION AUDIT TRAIL (SHOW WORK)",
          style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
        ),
        boxM,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: state.steps.map((step) {
              final isHeader = step.trim().startsWith(RegExp(r'^\d+\.'));
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  step,
                  style: GoogleFonts.shareTechMono(
                    color: isHeader ? Colors.tealAccent.withValues(alpha: 0.8) : Colors.white70,
                    fontSize: 12,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class EnergyFlowPainter extends CustomPainter {
  final double workInput;
  final double workOutput;
  final double loss;
  final double efficiency;

  EnergyFlowPainter({
    required this.workInput,
    required this.workOutput,
    required this.loss,
    required this.efficiency,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const padding = 40.0;
    final w = size.width - 2 * padding;
    final h = size.height - 2 * padding;

    // Inlet geometry settings
    const inletThickness = 70.0;
    final inletY = padding + h / 2 - inletThickness / 2;

    // Useful split calculation
    // Clamp values for rendering safety
    final double efficiencyClamped = efficiency.clamp(0, 200);
    final double outputRatio = (efficiencyClamped / 100.0).clamp(0.0, 1.0);
    final double lossRatio = (1.0 - outputRatio).clamp(0.0, 1.0);

    final outletThickness = inletThickness * outputRatio;
    final lossThickness = inletThickness * lossRatio;

    // Split junction X coordinate
    final splitX = padding + w * 0.45;

    // 1. Draw Sankey flows using smooth paths

    // Flow 1: Work Input (Left edge to split junction)
    final inputFlowPath = Path()
      ..moveTo(padding, inletY)
      ..lineTo(splitX, inletY)
      ..lineTo(splitX, inletY + inletThickness)
      ..lineTo(padding, inletY + inletThickness)
      ..close();

    final inputPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(inputFlowPath, inputPaint);

    // Flow 2: Useful Output (splits and flows horizontally to the right)
    // If output is greater than 0
    if (outletThickness > 0.5) {
      final outputY = inletY;
      final outputFlowPath = Path()
        ..moveTo(splitX, outputY)
        ..lineTo(padding + w, outputY)
        ..lineTo(padding + w, outputY + outletThickness)
        ..lineTo(splitX, outputY + outletThickness)
        ..close();

      final outputPaint = Paint()
        ..color = Colors.tealAccent.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawPath(outputFlowPath, outputPaint);

      // Draw border lines for outlet
      final outputBorderPaint = Paint()
        ..color = Colors.tealAccent.withValues(alpha: 0.5)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(splitX, outputY), Offset(padding + w, outputY), outputBorderPaint);
      canvas.drawLine(Offset(splitX, outputY + outletThickness), Offset(padding + w, outputY + outletThickness), outputBorderPaint);
    }

    // Flow 3: Energy Loss (splits and bends downwards to the bottom)
    if (lossThickness > 0.5) {
      final double lossStartX = splitX + inletThickness * outputRatio;
      final double lossEndX = splitX;
      final double lossEndY = padding + h;

      final lossFlowPath = Path()
        ..moveTo(lossEndX, inletY + inletThickness)
        ..quadraticBezierTo(lossEndX, lossEndY - 20, lossEndX, lossEndY)
        ..lineTo(lossEndX + lossThickness, lossEndY)
        ..quadraticBezierTo(lossEndX + lossThickness, inletY + inletThickness, lossStartX, inletY + inletThickness)
        ..close();

      final lossPaint = Paint()
        ..color = Colors.orangeAccent.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawPath(lossFlowPath, lossPaint);

      // Border lines for loss
      final lossBorderPaint = Paint()
        ..color = Colors.orangeAccent.withValues(alpha: 0.4)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      
      // Left border of loss stream
      final leftLossPath = Path()
        ..moveTo(lossEndX, inletY + inletThickness)
        ..quadraticBezierTo(lossEndX, lossEndY - 20, lossEndX, lossEndY);
      canvas.drawPath(leftLossPath, lossBorderPaint);

      // Right border of loss stream
      final rightLossPath = Path()
        ..moveTo(lossStartX, inletY + inletThickness)
        ..quadraticBezierTo(lossEndX + lossThickness, inletY + inletThickness, lossEndX + lossThickness, lossEndY);
      canvas.drawPath(rightLossPath, lossBorderPaint);
    }

    // Inlet borders
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(padding, inletY), Offset(splitX, inletY), borderPaint);
    canvas.drawLine(Offset(padding, inletY + inletThickness), Offset(splitX, inletY + inletThickness), borderPaint);

    // Helpers to format labels
    String fmt(double v) => v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');

    // 2. Text Annotations
    // Input Text (left edge)
    _drawText(
      canvas,
      textPainter,
      "INPUT ENERGY\n${fmt(workInput)} J",
      Offset(padding - 35, inletY + inletThickness / 2 - 15),
      Colors.white70,
      9,
      align: TextAlign.right,
    );

    // Output Text (right edge)
    if (outletThickness > 0.5) {
      _drawText(
        canvas,
        textPainter,
        "USEFUL WORK (W_out)\n${fmt(workOutput)} J (\u03b7 = ${fmt(efficiency)}%)",
        Offset(padding + w + 10, inletY + outletThickness / 2 - 15),
        Colors.tealAccent,
        9,
        bold: true,
      );
    }

    // Loss Text (bottom edge)
    if (lossThickness > 0.5) {
      _drawText(
        canvas,
        textPainter,
        "ENERGY LOSS (Dissipated Heat)\n${fmt(loss)} J",
        Offset(splitX - 30, padding + h + 10),
        Colors.orangeAccent,
        9,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    TextPainter tp,
    String text,
    Offset offset,
    Color color,
    double fontSize, {
    bool bold = false,
    TextAlign align = TextAlign.left,
  }) {
    tp.text = TextSpan(
      text: text,
      style: GoogleFonts.shareTechMono(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        height: 1.3,
      ),
    );
    tp.textAlign = align;
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant EnergyFlowPainter oldDelegate) {
    return oldDelegate.workInput != workInput ||
        oldDelegate.workOutput != workOutput ||
        oldDelegate.loss != loss ||
        oldDelegate.efficiency != efficiency;
  }
}
