import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/efficiency_model.dart';

part 'efficiency_ctrl.g.dart';

@riverpod
class EfficiencyCtrl extends _$EfficiencyCtrl {
  @override
  EfficiencyState build() {
    return const EfficiencyState();
  }

  void updateWorkInput(String val) {
    state = state.copyWith(inputWorkInput: val);
    _recalculate();
  }

  void updateWorkOutput(String val) {
    state = state.copyWith(inputWorkOutput: val);
    _recalculate();
  }

  void reset() {
    state = const EfficiencyState();
  }

  void _recalculate() {
    final win = double.tryParse(state.inputWorkInput);
    final wout = double.tryParse(state.inputWorkOutput);

    state = state.copyWith(
      workInput: win,
      workOutput: wout,
      efficiency: null,
      loss: null,
      steps: const [],
      errorMessage: null,
    );

    if (win == null || wout == null) return;

    if (win <= 0) {
      state = state.copyWith(errorMessage: "Work Input (Wᵢ\u2093) must be strictly positive (> 0).");
      return;
    }

    if (wout < 0) {
      state = state.copyWith(errorMessage: "Work Output (W_out) cannot be negative.");
      return;
    }

    final efficiencyVal = (wout / win) * 100;
    final lossVal = win - wout;

    final steps = [
      "1. Identify the given variables:",
      "   • Work Input (Wᵢ\u2093) = ${_fmt(win)} J",
      "   • Work Output (W_out) = ${_fmt(wout)} J",
      "2. State the definition formula for efficiency (\u03b7):",
      "   • \u03b7 = (W_out / Wᵢ\u2093) \u00b7 100%",
      "3. Compute the ratio of work output to work input:",
      "   • Ratio = ${_fmt(wout)} / ${_fmt(win)} = ${_fmt(wout / win)}",
      "4. Convert to a percentage:",
      "   • \u03b7 = ${_fmt(wout / win)} \u00b7 100 = ${_fmt(efficiencyVal)}%",
      "5. Calculate dissipated/lost energy:",
      "   • Dissipated Energy = Wᵢ\u2093 - W_out",
      "   • Dissipated Energy = ${_fmt(win)} - ${_fmt(wout)} = ${_fmt(lossVal)} J",
    ];

    if (wout > win) {
      steps.add(
        "Notice: Calculated efficiency is greater than 100%. While mathematically possible, this violates the Law of Conservation of Energy in a closed physical system.",
      );
    }

    state = state.copyWith(
      efficiency: efficiencyVal,
      loss: lossVal,
      steps: steps,
    );
  }

  String _fmt(double val) {
    if (val.isInfinite) return "\u221e";
    if (val.isNaN) return "NaN";
    if (val == 0) return "0";
    final fixed = val.toStringAsFixed(4);
    if (fixed.contains('.')) {
      final trimmed = fixed.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      return trimmed;
    }
    return fixed;
  }
}
