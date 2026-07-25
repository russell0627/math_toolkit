import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/screen_utils.dart';
import '../controller/acceleration_ctrl.dart';
import '../model/acceleration_model.dart';

class AccelerationView extends ConsumerStatefulWidget {
  final bool isCompact;
  const AccelerationView({super.key, this.isCompact = false});

  @override
  ConsumerState<AccelerationView> createState() => _AccelerationViewState();
}

class _AccelerationViewState extends ConsumerState<AccelerationView> {
  final TextEditingController _viController = TextEditingController();
  final TextEditingController _vfController = TextEditingController();
  final TextEditingController _tController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _speedChangeController = TextEditingController();

  final FocusNode _viFocus = FocusNode();
  final FocusNode _vfFocus = FocusNode();
  final FocusNode _tFocus = FocusNode();
  final FocusNode _aFocus = FocusNode();
  final FocusNode _speedChangeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _syncTextControllers();
  }

  void _syncTextControllers() {
    final state = ref.read(accelerationCtrlProvider);
    _viController.text = state.inputInitialVelocity;
    _vfController.text = state.inputFinalVelocity;
    _tController.text = state.inputTime;
    _aController.text = state.inputAcceleration;
    _speedChangeController.text = state.inputSpeedChange;
  }

  @override
  void dispose() {
    _viController.dispose();
    _vfController.dispose();
    _tController.dispose();
    _aController.dispose();
    _speedChangeController.dispose();
    _viFocus.dispose();
    _vfFocus.dispose();
    _tFocus.dispose();
    _aFocus.dispose();
    _speedChangeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accelerationCtrlProvider);
    final ctrl = ref.read(accelerationCtrlProvider.notifier);

    // Sync controllers if state changes externally and fields don't have focus
    if (!_viFocus.hasFocus && _viController.text != state.inputInitialVelocity) {
      _viController.text = state.inputInitialVelocity;
    }
    if (!_vfFocus.hasFocus && _vfController.text != state.inputFinalVelocity) {
      _vfController.text = state.inputFinalVelocity;
    }
    if (!_tFocus.hasFocus && _tController.text != state.inputTime) {
      _tController.text = state.inputTime;
    }
    if (!_aFocus.hasFocus && _aController.text != state.inputAcceleration) {
      _aController.text = state.inputAcceleration;
    }
    if (!_speedChangeFocus.hasFocus && _speedChangeController.text != state.inputSpeedChange) {
      _speedChangeController.text = state.inputSpeedChange;
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
                _buildModeSelector(state, ctrl),
                boxXXL,
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

  Widget _buildStatusBar(AccelerationState state) {
    final hasResult = state.hasResult;
    final isError = state.errorMessage != null;

    Color color = Colors.amberAccent;
    String text = "AWAITING INGESTION PARAMETERS...";
    IconData icon = Icons.hourglass_empty;

    if (isError) {
      color = Colors.redAccent;
      text = "PARAMETER ANOMALY DETECTED";
      icon = Icons.warning_amber_rounded;
    } else if (hasResult) {
      color = Colors.greenAccent;
      text = "KINEMATIC CALCULATION COMPILED";
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

  Widget _buildModeSelector(AccelerationState state, AccelerationCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SOLVER TARGET CONFIGURATION",
          style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
        ),
        boxM,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AccelerationSolveMode.values.map((mode) {
            final isSelected = state.solveMode == mode;
            return GestureDetector(
              onTap: () => ctrl.setSolveMode(mode),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.amberAccent.withValues(alpha: 0.1) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.amberAccent : Colors.white10,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  mode.label.toUpperCase(),
                  style: GoogleFonts.shareTechMono(
                    color: isSelected ? Colors.amberAccent : Colors.white24,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputSection(AccelerationState state, AccelerationCtrl ctrl) {
    final mode = state.solveMode;

    if (mode == AccelerationSolveMode.speedChange) {
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
              "KNOWN PARAMETER INGESTION",
              style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
            ),
            boxXL,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _speedChangeController,
                    focusNode: _speedChangeFocus,
                    label: "Speed Change (Δv)",
                    suffix: "m/s",
                    onChanged: ctrl.updateSpeedChange,
                  ),
                ),
                boxXL,
                Expanded(
                  child: _buildTextField(
                    controller: _tController,
                    focusNode: _tFocus,
                    label: "Time Interval (t)",
                    suffix: "s",
                    onChanged: ctrl.updateTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (mode == AccelerationSolveMode.velocityChange) {
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
              "KNOWN PARAMETER INGESTION",
              style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
            ),
            boxXL,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _aController,
                    focusNode: _aFocus,
                    label: "Acceleration (a)",
                    suffix: "m/s\u00b2",
                    onChanged: ctrl.updateAcceleration,
                  ),
                ),
                boxXL,
                Expanded(
                  child: _buildTextField(
                    controller: _tController,
                    focusNode: _tFocus,
                    label: "Time Interval (t)",
                    suffix: "s",
                    onChanged: ctrl.updateTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

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
            "KNOWN PARAMETER INGESTION",
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
          ),
          boxXL,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mode != AccelerationSolveMode.initialVelocity) ...[
                Expanded(
                  child: _buildTextField(
                    controller: _viController,
                    focusNode: _viFocus,
                    label: "Initial Velocity (vᵢ)",
                    suffix: "m/s",
                    onChanged: ctrl.updateInitialVelocity,
                  ),
                ),
                boxXL,
              ],
              if (mode != AccelerationSolveMode.finalVelocity) ...[
                Expanded(
                  child: _buildTextField(
                    controller: _vfController,
                    focusNode: _vfFocus,
                    label: "Final Velocity (v_f)",
                    suffix: "m/s",
                    onChanged: ctrl.updateFinalVelocity,
                  ),
                ),
                boxXL,
              ],
              if (mode != AccelerationSolveMode.acceleration) ...[
                Expanded(
                  child: _buildTextField(
                    controller: _aController,
                    focusNode: _aFocus,
                    label: "Acceleration (a)",
                    suffix: "m/s²",
                    onChanged: ctrl.updateAcceleration,
                  ),
                ),
                boxXL,
              ],
              if (mode != AccelerationSolveMode.time) ...[
                Expanded(
                  child: _buildTextField(
                    controller: _tController,
                    focusNode: _tFocus,
                    label: "Time Interval (t)",
                    suffix: "s",
                    onChanged: ctrl.updateTime,
                  ),
                ),
              ],
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
      style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 18),
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        isDense: true,
        labelText: label.toUpperCase(),
        labelStyle: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
        suffixText: suffix,
        suffixStyle: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amberAccent)),
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

  Widget _buildResultsSection(AccelerationState state) {
    String outputLabel = "";
    String outputUnit = "";

    switch (state.solveMode) {
      case AccelerationSolveMode.acceleration:
        outputLabel = "ACCELERATION (a)";
        outputUnit = "m/s²";
        break;
      case AccelerationSolveMode.initialVelocity:
        outputLabel = "INITIAL VELOCITY (vᵢ)";
        outputUnit = "m/s";
        break;
      case AccelerationSolveMode.finalVelocity:
        outputLabel = "FINAL VELOCITY (v_f)";
        outputUnit = "m/s";
        break;
      case AccelerationSolveMode.time:
        outputLabel = "TIME INTERVAL (t)";
        outputUnit = "s";
        break;
      case AccelerationSolveMode.speedChange:
        outputLabel = "ACCELERATION (a)";
        outputUnit = "m/s\u00b2";
        break;
      case AccelerationSolveMode.velocityChange:
        outputLabel = "VELOCITY CHANGE (Δv)";
        outputUnit = "m/s";
        break;
    }

    final resultStr = state.calculatedValue?.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '') ?? "---";
    final distStr = state.distance?.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '') ?? "---";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amberAccent.withValues(alpha: 0.02),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            "COMPILED SOLUTIONS",
            style: GoogleFonts.shareTechMono(color: Colors.amberAccent.withValues(alpha: 0.3), fontSize: 10),
          ),
          boxXL,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetricCard(outputLabel, "$resultStr $outputUnit", Colors.amberAccent),
              if (state.distance != null)
                _buildMetricCard("TOTAL DISPLACEMENT (d)", "$distStr m", Colors.cyanAccent),
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

  Widget _buildVisualizationSection(AccelerationState state) {
    final vi = state.vInitial ?? 0.0;
    final vf = state.vFinal ?? 0.0;
    final t = state.time ?? 1.0;
    final a = state.acceleration ?? 0.0;
    final d = state.distance ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "VELOCITY VS TIME GRAPH (VISUAL AUDIT)",
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
              painter: VelocityTimePainter(
                vi: vi,
                vf: vf,
                time: t,
                acceleration: a,
                displacement: d,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkSection(AccelerationState state) {
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
                    color: isHeader ? Colors.amberAccent.withValues(alpha: 0.8) : Colors.white70,
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

class VelocityTimePainter extends CustomPainter {
  final double vi;
  final double vf;
  final double time;
  final double acceleration;
  final double displacement;

  VelocityTimePainter({
    required this.vi,
    required this.vf,
    required this.time,
    required this.acceleration,
    required this.displacement,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final paintAxes = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final paintLine = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final paintArea = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    const padding = 40.0;
    final w = size.width - 2 * padding;
    final h = size.height - 2 * padding;

    // Grid coordinates conversion helper
    // X axis represents time from 0 to 'time'
    // Y axis represents velocity
    final vMin = math.min(0.0, math.min(vi, vf));
    final vMax = math.max(0.0, math.max(vi, vf));

    // Pad velocity range a bit to keep points within bounds
    final vRange = vMax - vMin;
    final yMinBound = vMin - (vRange > 0 ? vRange * 0.15 : 5.0);
    final yMaxBound = vMax + (vRange > 0 ? vRange * 0.15 : 5.0);
    final yBoundSpan = yMaxBound - yMinBound;

    double toScreenX(double t) {
      return padding + (t / time) * w;
    }

    double toScreenY(double v) {
      // Y is inverted in Flutter
      return padding + h - ((v - yMinBound) / yBoundSpan) * h;
    }

    // 1. Draw Grid
    const gridCols = 8;
    const gridRows = 6;
    for (int i = 0; i <= gridCols; i++) {
      final x = padding + (i / gridCols) * w;
      canvas.drawLine(Offset(x, padding), Offset(x, padding + h), paintGrid);
    }
    for (int j = 0; j <= gridRows; j++) {
      final y = padding + (j / gridRows) * h;
      canvas.drawLine(Offset(padding, y), Offset(padding + w, y), paintGrid);
    }

    // 2. Draw Y=0 Axis (if visible)
    if (yMinBound <= 0 && yMaxBound >= 0) {
      final yZero = toScreenY(0);
      canvas.drawLine(Offset(padding, yZero), Offset(padding + w, yZero), paintAxes..color = Colors.white38);
    }

    // 3. Draw Main Axes
    canvas.drawLine(const Offset(padding, padding), Offset(padding, padding + h), paintAxes); // Y axis
    canvas.drawLine(Offset(padding, padding + h), Offset(padding + w, padding + h), paintAxes); // X axis

    // Coordinates of key plot points
    final xStart = toScreenX(0);
    final yStart = toScreenY(vi);
    final xEnd = toScreenX(time);
    final yEnd = toScreenY(vf);
    final yZeroScreen = toScreenY(0);

    // 4. Draw Shaded Displacement Area
    // The physical displacement is the area between the curve and the Y=0 (time) axis.
    final path = Path()
      ..moveTo(xStart, yZeroScreen)
      ..lineTo(xStart, yStart)
      ..lineTo(xEnd, yEnd)
      ..lineTo(xEnd, yZeroScreen)
      ..close();
    canvas.drawPath(path, paintArea);

    // 5. Draw Velocity Line
    canvas.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd), paintLine);

    // 6. Draw Points at Start and End
    final paintPoints = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(xStart, yStart), 4.0, paintPoints);
    canvas.drawCircle(Offset(xEnd, yEnd), 4.0, paintPoints);

    // Helper to format values
    String fmtVal(double v) => v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');

    // 7. Labels and Annotations
    // Origin or Time axis labels
    _drawText(canvas, textPainter, "0s", Offset(padding - 10, padding + h + 5), Colors.white38, 9);
    _drawText(canvas, textPainter, "${fmtVal(time)}s", Offset(padding + w - 10, padding + h + 5), Colors.amberAccent, 9);
    _drawText(canvas, textPainter, "t (time)", Offset(padding + w / 2 - 20, padding + h + 18), Colors.white24, 9);

    // Velocity labels
    _drawText(canvas, textPainter, "${fmtVal(vi)} m/s", Offset(padding - 35, yStart - 6), Colors.amberAccent, 9);
    _drawText(canvas, textPainter, "${fmtVal(vf)} m/s", Offset(padding - 35, yEnd - 6), Colors.amberAccent, 9);
    _drawText(canvas, textPainter, "v (vel)", const Offset(padding - 30, padding - 15), Colors.white24, 9);

    // Area text annotation (Displacement)
    final yMiddle = (yStart + yEnd) / 2;
    final yZeroPos = yZeroScreen;
    final labelY = yMiddle + (yZeroPos - yMiddle) / 2 - 5;
    _drawText(
      canvas,
      textPainter,
      "Area (d) = ${fmtVal(displacement)} m",
      Offset(padding + w / 2 - 50, labelY.clamp(padding + 10, padding + h - 10)),
      Colors.cyanAccent.withValues(alpha: 0.8),
      9,
      bold: true,
    );

    // Slope text annotation (Acceleration)
    final midX = padding + w / 2;
    final midY = (yStart + yEnd) / 2;
    _drawText(
      canvas,
      textPainter,
      "a = ${fmtVal(acceleration)} m/s²",
      Offset(midX - 45, midY - 18),
      Colors.amberAccent,
      9,
      bold: true,
    );
  }

  void _drawText(
    Canvas canvas,
    TextPainter tp,
    String text,
    Offset offset,
    Color color,
    double fontSize, {
    bool bold = false,
  }) {
    tp.text = TextSpan(
      text: text,
      style: GoogleFonts.shareTechMono(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant VelocityTimePainter oldDelegate) {
    return oldDelegate.vi != vi ||
        oldDelegate.vf != vf ||
        oldDelegate.time != time ||
        oldDelegate.acceleration != acceleration ||
        oldDelegate.displacement != displacement;
  }
}
