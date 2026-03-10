import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../pythagorean/controller/pythagorean_ctrl.dart';
import '../../pythagorean/model/pythagorean_model.dart';
import '../controller/radical_ctrl.dart';
import '../model/radical_model.dart';

class RadicalView extends ConsumerStatefulWidget {
  final bool isCompact;
  const RadicalView({super.key, this.isCompact = false});

  @override
  ConsumerState<RadicalView> createState() => _RadicalViewState();
}

class _RadicalViewState extends ConsumerState<RadicalView> {
  late TextEditingController _inputController;
  late FocusNode _inputFocusNode;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(radicalCtrlProvider);
    _inputController = TextEditingController(
      text: initialState.inputRadicand?.toString() ?? "",
    );
    _inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(radicalCtrlProvider);
    final ctrl = ref.read(radicalCtrlProvider.notifier);

    // Sync controller if state changes externally
    final text = state.inputRadicand?.toString() ?? "";
    if (_inputController.text != text && !_inputFocusNode.hasFocus) {
      _inputController.text = text;
    }

    // Auto-sync with Pythagorean result if active
    ref.listen<PythagoreanState>(pythagoreanCtrlProvider, (prev, next) {
      final solved = next.solvedSideValue;
      if (solved != null && !next.isPerfectSquareResult && !_inputFocusNode.hasFocus) {
        final n = (solved * solved).round();
        if (n != state.inputRadicand) {
          ctrl.simplify(n.toString());
        }
      }
    });

    return Column(
      children: [
        _buildProcessingStatus(state),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
            child: Column(
              children: [
                _buildRequisitionField(ctrl),
                SizedBox(height: widget.isCompact ? 24 : 40),
                if (!state.isEmpty) ...[
                  _buildReductionSection(state),
                  const SizedBox(height: 16),
                  _buildValuationSection(state),
                  if (!widget.isCompact) ...[
                    const SizedBox(height: 32),
                    _buildTacticalStamp(),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingStatus(RadicalState state) {
    final isActive = !state.isEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: Colors.purpleAccent.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.sync : Icons.pause_circle_outline,
            size: 14,
            color: Colors.purpleAccent,
          ),
          const SizedBox(width: 12),
          Text(
            isActive ? "REDUCTION PROTOCOL ACTIVE" : "AWAITING RADICAND...",
            style: GoogleFonts.shareTechMono(color: Colors.purpleAccent, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildRequisitionField(RadicalCtrl ctrl) {
    return Container(
      padding: EdgeInsets.all(widget.isCompact ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RADICAND INPUT",
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: widget.isCompact ? 8 : 10),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _inputController,
            style: GoogleFonts.shareTechMono(color: Colors.purpleAccent, fontSize: widget.isCompact ? 18 : 24),
            decoration: InputDecoration(
              isDense: true,
              hintText: "√n",
              hintStyle: GoogleFonts.shareTechMono(color: Colors.white10),
              prefixIcon: Icon(Icons.square_foot, color: Colors.white10, size: widget.isCompact ? 16 : 20),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.purpleAccent)),
            ),
            focusNode: _inputFocusNode,
            onChanged: ctrl.simplify,
          ),
        ],
      ),
    );
  }

  Widget _buildReductionSection(RadicalState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(widget.isCompact ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.purpleAccent.withValues(alpha: 0.02),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "EXACT RADICAL EQUIVALENCY",
            style: GoogleFonts.shareTechMono(color: Colors.purpleAccent.withValues(alpha: 0.3), fontSize: 10),
          ),
          const SizedBox(height: 16),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "√${state.inputRadicand}",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white24,
                    fontSize: widget.isCompact ? 24 : 32,
                  ),
                ),
                Text(
                  " = ",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white10,
                    fontSize: widget.isCompact ? 24 : 32,
                  ),
                ),
                Text(
                  state.displayResult,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.purpleAccent,
                    fontSize: widget.isCompact ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: widget.isCompact ? 2 : 4,
                  ),
                ),
              ],
            ),
          ),
          if (state.decimalValue != null) ...[
            const SizedBox(height: 16),
            Text(
              "DECIMAL VALUATION: ≈ ${state.decimalValue!.toStringAsFixed(6)}",
              style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTacticalStamp() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4), width: 2),
      ),
      child: Transform.rotate(
        angle: -0.1,
        child: Text(
          "REDUCTION VERIFIED",
          style: GoogleFonts.shareTechMono(
            color: Colors.purpleAccent.withValues(alpha: 0.4),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildValuationSection(RadicalState state) {
    if (state.isPerfectSquare) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.purpleAccent.withValues(alpha: 0.05),
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(
            "COMPUTATIONAL ESTIMATION RANGE",
            style: GoogleFonts.shareTechMono(color: Colors.purpleAccent.withValues(alpha: 0.5), fontSize: 10),
          ),
          const SizedBox(height: 20),
          _buildRangeGraphic(state),
          const SizedBox(height: 24),
          Text(
            "THE IRRATIONAL SQUARE ROOT OF ${state.inputRadicand} SITS BETWEEN THE PERFECT SQUARES OF ${state.lowerBound! * state.lowerBound!} AND ${state.upperBound! * state.upperBound!}.",
            textAlign: TextAlign.center,
            style: GoogleFonts.shareTechMono(
              color: Colors.white24,
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeGraphic(RadicalState state) {
    if (state.lowerBound == null || state.upperBound == null) return const SizedBox.shrink();
    final l2 = state.lowerBound! * state.lowerBound!;
    final u2 = state.upperBound! * state.upperBound!;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBoundItem("√$l2", state.lowerBound.toString()),
          Icon(Icons.chevron_left, color: Colors.purpleAccent.withValues(alpha: 0.1), size: 12),
          _buildBoundItem("√${state.inputRadicand}", "≈ ${state.decimalValue!.toStringAsFixed(2)}", isFocus: true),
          Icon(Icons.chevron_left, color: Colors.purpleAccent.withValues(alpha: 0.1), size: 12),
          _buildBoundItem("√$u2", state.upperBound.toString()),
        ],
      ),
    );
  }

  Widget _buildBoundItem(String label, String value, {bool isFocus = false}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.shareTechMono(
            color: isFocus ? Colors.white : Colors.purpleAccent.withValues(alpha: 0.6),
            fontSize: isFocus ? 24 : 20,
            fontWeight: isFocus ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.shareTechMono(
            color: isFocus ? Colors.purpleAccent : Colors.white10,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
