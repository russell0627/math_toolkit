import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/transformation_sequence_ctrl.dart';
import '../model/transformation_sequence_model.dart';

class TransformationSequenceView extends ConsumerWidget {
  final bool isCompact;
  const TransformationSequenceView({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transformationSequenceCtrlProvider);
    final ctrl = ref.read(transformationSequenceCtrlProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShapePreview(state),
                const SizedBox(height: 24),
                _buildVertexManager(context, state, ctrl),
                const SizedBox(height: 24),
                _buildActionButtons(context, ctrl),
                const SizedBox(height: 24),
                _buildSequenceNotation(state),
                const SizedBox(height: 24),
                _buildHistoryList(state, ctrl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShapePreview(TransformationSequenceState state) {
    return Container(
      height: isCompact ? 240 : 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRect(
        child: CustomPaint(
          painter: ShapePainter(state: state, isCompact: isCompact),
        ),
      ),
    );
  }

  Widget _buildVertexManager(BuildContext context, TransformationSequenceState state, TransformationSequenceCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SHAPE VERTICES",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _showQuickShapeDialog(context, ctrl),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.auto_awesome, size: 14, color: Colors.blueAccent),
                  label: Text("QUICK", style: GoogleFonts.shareTechMono(fontSize: 10, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => ctrl.addPoint(const Offset(0, 0)),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.points.asMap().entries.map((entry) {
          final idx = entry.key;
          final p = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text("P${idx + 1}", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12)),
                ),
                Expanded(
                  child: _buildCoordinateField(
                    label: "X",
                    value: p.dx,
                    onChanged: (val) {
                      final x = double.tryParse(val) ?? p.dx;
                      ctrl.updatePoint(idx, Offset(x, p.dy));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCoordinateField(
                    label: "Y",
                    value: p.dy,
                    onChanged: (val) {
                      final y = double.tryParse(val) ?? p.dy;
                      ctrl.updatePoint(idx, Offset(p.dx, y));
                    },
                  ),
                ),
                IconButton(
                  onPressed: () => ctrl.removePoint(idx),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _showQuickShapeDialog(BuildContext context, TransformationSequenceCtrl ctrl) {
    String input = "2x2";
    bool isCentered = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.white10),
              ),
              title: Text("Quick Shape Generator", style: GoogleFonts.shareTechMono(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter dimensions (W x H):", style: GoogleFonts.shareTechMono(color: Colors.white70)),
                  const SizedBox(height: 8),
                  TextFormField(
                    autofocus: true,
                    initialValue: input,
                    style: GoogleFonts.shareTechMono(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "e.g., 2x4",
                      hintStyle: GoogleFonts.shareTechMono(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.black26,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                    onChanged: (val) => input = val,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Switch(
                        value: isCentered,
                        onChanged: (val) => setState(() => isCentered = val),
                        activeThumbColor: Colors.blueAccent,
                        activeTrackColor: Colors.blueAccent.withValues(alpha: 0.3),
                      ),
                      const SizedBox(width: 8),
                      Text("Center on origin", style: GoogleFonts.shareTechMono(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("CANCEL", style: GoogleFonts.shareTechMono(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () {
                    final parts = input.toLowerCase().split('x');
                    if (parts.length == 2) {
                      final w = double.tryParse(parts[0].trim());
                      final h = double.tryParse(parts[1].trim());
                      if (w != null && h != null) {
                        ctrl.generateShape(w, h, isCentered: isCentered);
                        Navigator.of(context).pop();
                        return;
                      }
                    }
                  },
                  child: Text("GENERATE", style: GoogleFonts.shareTechMono(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCoordinateField({required String label, required double value, required ValueChanged<String> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(label, style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: TextEditingController(text: value.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), ''))..selection = TextSelection.fromPosition(TextPosition(offset: value.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '').length)),
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, TransformationSequenceCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AVAILABLE TRANSFORMATIONS",
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TransformationType.values.map((type) {
            return _buildActionButton(type.label, () => _handleAction(context, ctrl, type));
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton("RESET SEQ", ctrl.reset, color: Colors.redAccent.withValues(alpha: 0.1)),
            ),
          ],
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, TransformationSequenceCtrl ctrl, TransformationType type) {
    switch (type) {
      case TransformationType.translate:
        _showTranslateDialog(context, ctrl);
      case TransformationType.dilate:
        _showDilateDialog(context, ctrl);
      case TransformationType.rotate90CCW:
      case TransformationType.rotate90CW:
      case TransformationType.rotate180:
      case TransformationType.rotate270CCW:
      case TransformationType.rotate270CW:
        _showRotateDialog(context, ctrl, type);
      default:
        ctrl.addTransformation(type);
    }
  }

  void _showTranslateDialog(BuildContext context, TransformationSequenceCtrl ctrl) {
    final hCtrl = TextEditingController(text: "0");
    final kCtrl = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("TRANSLATE BY (h, k)", style: GoogleFonts.shareTechMono(color: Colors.blueAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField("h (horizontal)", hCtrl),
            _buildDialogField("k (vertical)", kCtrl),
          ],
        ),
        actions: [
          _buildDialogAction("CANCEL", () => Navigator.pop(context)),
          _buildDialogAction("APPLY", () {
            final h = int.tryParse(hCtrl.text) ?? 0;
            final k = int.tryParse(kCtrl.text) ?? 0;
            ctrl.addTransformation(TransformationType.translate, h: h, k: k);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  void _showDilateDialog(BuildContext context, TransformationSequenceCtrl ctrl) {
    final sCtrl = TextEditingController(text: "2");
    final hCtrl = TextEditingController(text: "0");
    final kCtrl = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("DILATE BY (k)", style: GoogleFonts.shareTechMono(color: Colors.orangeAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField("Scale Factor (k)", sCtrl),
            const SizedBox(height: 16),
            Text("CENTER OF DILATION", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
            _buildDialogField("Center X", hCtrl),
            _buildDialogField("Center Y", kCtrl),
          ],
        ),
        actions: [
          _buildDialogAction("CANCEL", () => Navigator.pop(context)),
          _buildDialogAction("APPLY", () {
            final s = double.tryParse(sCtrl.text) ?? 1.0;
            final h = double.tryParse(hCtrl.text) ?? 0.0;
            final k = double.tryParse(kCtrl.text) ?? 0.0;
            ctrl.addTransformation(TransformationType.dilate, scale: s, centerX: h, centerY: k);
            Navigator.pop(context);
          }, color: Colors.orangeAccent),
        ],
      ),
    );
  }

  void _showRotateDialog(BuildContext context, TransformationSequenceCtrl ctrl, TransformationType type) {
    final hCtrl = TextEditingController(text: "0");
    final kCtrl = TextEditingController(text: "0");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(type.label, style: GoogleFonts.shareTechMono(color: Colors.blueAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("CENTER OF ROTATION", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
            _buildDialogField("Center X", hCtrl),
            _buildDialogField("Center Y", kCtrl),
          ],
        ),
        actions: [
          _buildDialogAction("CANCEL", () => Navigator.pop(context)),
          _buildDialogAction("APPLY", () {
            final h = double.tryParse(hCtrl.text) ?? 0.0;
            final k = double.tryParse(kCtrl.text) ?? 0.0;
            ctrl.addTransformation(type, centerX: h, centerY: k);
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      style: GoogleFonts.shareTechMono(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
      ),
    );
  }

  Widget _buildDialogAction(String label, VoidCallback onPressed, {Color? color}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: GoogleFonts.shareTechMono(color: color ?? Colors.blueAccent)),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSequenceNotation(TransformationSequenceState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "COMPOSITE NOTATION",
            style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNotationUnit("(x, y)", state.points, isQuickShape: state.isQuickShape),
              ...state.steps.map((step) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.arrow_downward, color: Colors.white10, size: 16),
                  ),
                  _buildNotationUnit("(${step.expressionX}, ${step.expressionY})", step.pointResults, isQuickShape: state.isQuickShape),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotationUnit(String content, List<Offset> points, {bool isQuickShape = false}) {
    String preview = "EMPTY";
    if (points.isNotEmpty) {
      if (points.length == 1) {
        preview = "(${points[0].dx.toStringAsFixed(1)}, ${points[0].dy.toStringAsFixed(1)})";
      } else {
        preview = points.map((p) => "(${p.dx.toStringAsFixed(1)}, ${p.dy.toStringAsFixed(1)})").join(", ");
      }
    }

    String areaLabel = "";
    if (isQuickShape && points.length == 4) {
      final d1 = (points[1] - points[0]).distance;
      final d2 = (points[2] - points[1]).distance;
      String format(double v) => v.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
      areaLabel = "Area: ${format(d1)} x ${format(d2)}";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.1),
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            content,
            style: GoogleFonts.shareTechMono(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (areaLabel.isNotEmpty)
            Text(
              areaLabel,
              style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 4),
          Text(
            preview,
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(TransformationSequenceState state, TransformationSequenceCtrl ctrl) {
    if (state.steps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TRANSFORMATION LOG (TAP TO PREVIEW STEP)",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
            ),
            if (state.selectedStepIndex != null)
              TextButton(
                onPressed: () => ctrl.selectStep(null),
                child: Text("CLEAR PREVIEW", style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 10)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...state.steps.asMap().entries.map((entry) {
          final idx = entry.key;
          final step = entry.value;
          final isSelected = state.selectedStepIndex == idx;

          String subtitle = "";
          if (step.type == TransformationType.translate) {
            subtitle = "T(${step.h}, ${step.k})";
          } else if (step.type == TransformationType.dilate) {
            subtitle = "S(${step.scale}) at (${step.centerX}, ${step.centerY})";
          } else if (step.centerX != 0 || step.centerY != 0) {
            subtitle = "at (${step.centerX}, ${step.centerY})";
          }

          return InkWell(
            onTap: () => ctrl.selectStep(isSelected ? null : idx),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orangeAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
                border: Border.all(color: isSelected ? Colors.orangeAccent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.type.label,
                        style: GoogleFonts.shareTechMono(color: isSelected ? Colors.orangeAccent : Colors.white70, fontSize: 13),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: GoogleFonts.shareTechMono(color: Colors.blueAccent.withValues(alpha: 0.4), fontSize: 11),
                        ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => ctrl.removeStep(idx),
                    icon: const Icon(Icons.delete_outline, color: Colors.white10, size: 16),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class ShapePainter extends CustomPainter {
  final TransformationSequenceState state;
  final bool isCompact;
  ShapePainter({required this.state, this.isCompact = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = isCompact ? 20.0 : 40.0;

    // Draw Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += scale) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += scale) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw Axes
    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);

    if (state.points.isEmpty) return;

    // Draw Base Shape
    _drawShape(canvas, state.points, center, scale, Colors.white24, isDashed: true);

    // Draw Ghost Shape (Intermediate Step)
    if (state.selectedStepIndex != null && state.selectedStepIndex! < state.steps.length) {
      _drawShape(canvas, state.steps[state.selectedStepIndex!].pointResults, center, scale, Colors.orangeAccent.withValues(alpha: 0.5), isDashed: true);
    }

    // Draw Final Shape
    if (state.steps.isNotEmpty) {
      _drawShape(canvas, state.steps.last.pointResults, center, scale, Colors.blueAccent);
    }
  }

  void _drawShape(Canvas canvas, List<Offset> points, Offset center, double scale, Color color, {bool isDashed = false}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final p = Offset(center.dx + points[i].dx * scale, center.dy - points[i].dy * scale);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    if (points.length > 2) {
      path.close();
      canvas.drawPath(path, fillPaint);
    }
    canvas.drawPath(path, paint);

    // Draw Points
    final dotPaint = Paint()..color = color;
    for (var p in points) {
      canvas.drawCircle(Offset(center.dx + p.dx * scale, center.dy - p.dy * scale), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) => true;
}
