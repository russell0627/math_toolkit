import 'dart:math' as math;
import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../settings/controller/settings_ctrl.dart';
import '../controller/triangle_solver_ctrl.dart';
import '../model/triangle_model.dart';

class TriangleView extends ConsumerStatefulWidget {
  final bool isCompact;
  const TriangleView({super.key, this.isCompact = false});

  @override
  ConsumerState<TriangleView> createState() => _TriangleViewState();
}

class _TriangleViewState extends ConsumerState<TriangleView> {
  late TextEditingController _controllerA;
  late TextEditingController _controllerB;
  late TextEditingController _controllerC;
  late TextEditingController _extAController;
  late TextEditingController _extBController;
  late TextEditingController _extCController;
  late FocusNode _focusA;
  late FocusNode _focusB;
  late FocusNode _focusC;
  late FocusNode _focusExtA;
  late FocusNode _focusExtB;
  late FocusNode _focusExtC;

  @override
  void initState() {
    super.initState();
    _controllerA = TextEditingController();
    _controllerB = TextEditingController();
    _controllerC = TextEditingController();
    _extAController = TextEditingController();
    _extBController = TextEditingController();
    _extCController = TextEditingController();
    _focusA = FocusNode();
    _focusB = FocusNode();
    _focusC = FocusNode();
    _focusExtA = FocusNode();
    _focusExtB = FocusNode();
    _focusExtC = FocusNode();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    _controllerB.dispose();
    _controllerC.dispose();
    _extAController.dispose();
    _extBController.dispose();
    _extCController.dispose();
    _focusA.dispose();
    _focusB.dispose();
    _focusC.dispose();
    _focusExtA.dispose();
    _focusExtB.dispose();
    _focusExtC.dispose();
    super.dispose();
  }

  void _syncControllers(TriangleState state) {
    _updateIfChanged(_controllerA, state.angleA, _focusA, state.isUserA);
    _updateIfChanged(_controllerB, state.angleB, _focusB, state.isUserB);
    _updateIfChanged(_controllerC, state.angleC, _focusC, state.isUserC);
    _updateIfChanged(_extAController, state.extA, _focusExtA, state.isUserExtA);
    _updateIfChanged(_extBController, state.extB, _focusExtB, state.isUserExtB);
    _updateIfChanged(_extCController, state.extC, _focusExtC, state.isUserExtC);
  }

  void _updateIfChanged(TextEditingController controller, double? value, FocusNode focusNode, bool isUser) {
    if (value == null) {
      if (controller.text.isNotEmpty) {
        if (isUser && focusNode.hasFocus) return;
        controller.text = "";
      }
      return;
    }

    final text = value.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    if (controller.text != text) {
      if (isUser && focusNode.hasFocus) return;
      controller.text = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(triangleSolverCtrlProvider);
    final ctrl = ref.read(triangleSolverCtrlProvider.notifier);
    final settings = ref.watch(settingsCtrlProvider);
    final styles = context.textStyles;

    _syncControllers(state);

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: TrianglePainter(state, isCompact: widget.isCompact),
            ),
          ),
        ),
        Column(
          children: [
            _buildProtocolSelector(state, ctrl, styles, settings),
            _buildAlignmentStatus(state, styles),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
                child: Column(
                  children: [
                    _buildVertexUnit(
                      settings.useBureauNaming ? "VERTEX ALPHA (A)" : "VERTEX A",
                      _controllerA,
                      _extAController,
                      _focusA,
                      _focusExtA,
                      ctrl.updateAngleA,
                      ctrl.updateExtA,
                      state.isUserA,
                      state.isUserExtA,
                      settings,
                    ),
                    const SizedBox(height: 24),
                    _buildVertexUnit(
                      settings.useBureauNaming ? "VERTEX BETA (B)" : "VERTEX B",
                      _controllerB,
                      _extBController,
                      _focusB,
                      _focusExtB,
                      ctrl.updateAngleB,
                      ctrl.updateExtB,
                      state.isUserB,
                      state.isUserExtB,
                      settings,
                    ),
                    const SizedBox(height: 24),
                    _buildVertexUnit(
                      settings.useBureauNaming ? "VERTEX GAMMA (C)" : "VERTEX C",
                      _controllerC,
                      _extCController,
                      _focusC,
                      _focusExtC,
                      ctrl.updateAngleC,
                      ctrl.updateExtC,
                      state.isUserC,
                      state.isUserExtC,
                      settings,
                    ),
                    if (state.angleA != null && state.angleB != null && state.angleC != null) ...[
                      const SizedBox(height: 24),
                      _buildEstimationSummary(state, settings),
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

  Widget _buildProtocolSelector(TriangleState state, TriangleSolverCtrl ctrl, dynamic styles, SettingsState settings) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            widget.isCompact
                ? (settings.useBureauNaming ? "P:" : "T:")
                : (settings.useBureauNaming ? "ALIGNMENT PROTOCOL:" : "TRIANGLE TYPE:"),
            style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: TriangleType.values.map((type) {
                  final isSelected = state.type == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        type.label,
                        style: GoogleFonts.shareTechMono(
                          color: isSelected ? Colors.black : Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => ctrl.setType(type),
                      backgroundColor: Colors.transparent,
                      selectedColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlignmentStatus(TriangleState state, dynamic styles) {
    final sum = state.interiorSum;
    final isError = !state.isValidSum;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: isError ? Colors.redAccent.withValues(alpha: 0.1) : Colors.greenAccent.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(
            isError ? Icons.warning_amber : Icons.check_circle_outline,
            size: 12,
            color: isError ? Colors.redAccent : Colors.greenAccent,
          ),
          const SizedBox(width: 12),
          Text(
            "SUM: ${sum.toStringAsFixed(1)}°",
            style: GoogleFonts.shareTechMono(
              color: isError ? Colors.redAccent : Colors.greenAccent,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVertexUnit(
    String title,
    TextEditingController intCtrl,
    TextEditingController extCtrl,
    FocusNode intFocus,
    FocusNode extFocus,
    Function(double?) onIntChanged,
    Function(double?) onExtChanged,
    bool isUserInt,
    bool isUserExt,
    SettingsState settings,
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
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: widget.isCompact ? 7 : 9),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAngleField(
                  settings.useBureauNaming ? "INT" : "INNER",
                  intCtrl,
                  intFocus,
                  onIntChanged,
                  Colors.greenAccent,
                  isUserInt,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAngleField(
                  settings.useBureauNaming ? "EXT" : "OUTER",
                  extCtrl,
                  extFocus,
                  onExtChanged,
                  Colors.blueAccent,
                  isUserExt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngleField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    Function(double?) onChanged,
    Color accent,
    bool isUser,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.shareTechMono(color: accent.withValues(alpha: 0.3), fontSize: 7)),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          style: GoogleFonts.shareTechMono(
            color: isUser ? accent : accent.withValues(alpha: 0.3),
            fontSize: widget.isCompact ? 14 : 16,
          ),
          decoration: const InputDecoration(
            isDense: true,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
          ),
          onChanged: (val) => onChanged(double.tryParse(val)),
        ),
      ],
    );
  }

  Widget _buildEstimationSummary(TriangleState state, SettingsState settings) {
    // Simple summary for any irrational-looking angles
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Text(
            settings.useBureauNaming ? "GEOMETRIC VALUATION RANGE" : "TRIANGLE CALCULATION SUMMARY",
            style: GoogleFonts.shareTechMono(color: Colors.greenAccent.withValues(alpha: 0.5), fontSize: 8),
          ),
          const SizedBox(height: 8),
          Text(
            settings.useBureauNaming ? "COMPUTATION WITHIN RATIONAL PARAMETERS" : "ANGLES CALCULATED CORRECTLY",
            style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final TriangleState state;
  final bool isCompact;

  TrianglePainter(this.state, {this.isCompact = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (!state.isValidSum || !state.isFullInterior) return;
    final paint = Paint()
      ..color = Colors.amberAccent.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke;

    final double radA = state.angleA! * (math.pi / 180);
    final double radB = state.angleB! * (math.pi / 180);

    final double sideLength = math.min(size.width, size.height) * (isCompact ? 0.22 : 0.4);
    final double c = sideLength;
    final double bArr = (c * math.sin(radB)) / math.sin(math.pi - radA - radB);

    final pA = const Offset(0, 0);
    final pB = Offset(c, 0);
    final pC = Offset(bArr * math.cos(radA), -bArr * math.sin(radA));

    final boundsAB = Rect.fromPoints(pA, pB);
    final bounds = Rect.fromLTRB(
      math.min(boundsAB.left, pC.dx),
      math.min(boundsAB.top, pC.dy),
      math.max(boundsAB.right, pC.dx),
      math.max(boundsAB.bottom, pC.dy),
    );
    final centerOffset = Offset(
      size.width / 2 - bounds.center.dx,
      size.height / 2 - bounds.center.dy + (isCompact ? 130 : 500),
    );

    final path = Path()
      ..moveTo(pA.dx + centerOffset.dx, pA.dy + centerOffset.dy)
      ..lineTo(pB.dx + centerOffset.dx, pB.dy + centerOffset.dy)
      ..lineTo(pC.dx + centerOffset.dx, pC.dy + centerOffset.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) => state != oldDelegate.state;
}
