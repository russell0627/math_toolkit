import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/acceleration_model.dart';

part 'acceleration_ctrl.g.dart';

@riverpod
class AccelerationCtrl extends _$AccelerationCtrl {
  @override
  AccelerationState build() {
    return const AccelerationState();
  }

  void setSolveMode(AccelerationSolveMode mode) {
    state = state.copyWith(
      solveMode: mode,
      calculatedValue: null,
      distance: null,
      steps: const [],
      errorMessage: null,
    );
    _recalculate();
  }

  void updateInitialVelocity(String val) {
    state = state.copyWith(inputInitialVelocity: val);
    _recalculate();
  }

  void updateFinalVelocity(String val) {
    state = state.copyWith(inputFinalVelocity: val);
    _recalculate();
  }

  void updateTime(String val) {
    state = state.copyWith(inputTime: val);
    _recalculate();
  }

  void updateAcceleration(String val) {
    state = state.copyWith(inputAcceleration: val);
    _recalculate();
  }

  void updateSpeedChange(String val) {
    state = state.copyWith(inputSpeedChange: val);
    _recalculate();
  }

  void reset() {
    state = AccelerationState(solveMode: state.solveMode);
  }

  void _recalculate() {
    final mode = state.solveMode;
    final vi = double.tryParse(state.inputInitialVelocity);
    final vf = double.tryParse(state.inputFinalVelocity);
    final t = double.tryParse(state.inputTime);
    final a = double.tryParse(state.inputAcceleration);
    final dv = double.tryParse(state.inputSpeedChange);

    // Keep parsed values in state
    state = state.copyWith(
      vInitial: vi,
      vFinal: vf,
      time: t,
      acceleration: a,
      speedChange: dv,
      calculatedValue: null,
      distance: null,
      steps: const [],
      errorMessage: null,
    );

    switch (mode) {
      case AccelerationSolveMode.acceleration:
        _calculateAcceleration(vi, vf, t);
        break;
      case AccelerationSolveMode.initialVelocity:
        _calculateInitialVelocity(vf, a, t);
        break;
      case AccelerationSolveMode.finalVelocity:
        _calculateFinalVelocity(vi, a, t);
        break;
      case AccelerationSolveMode.time:
        _calculateTime(vi, vf, a);
        break;
      case AccelerationSolveMode.speedChange:
        _calculateSimpleAcceleration(dv, t);
        break;
      case AccelerationSolveMode.velocityChange:
        _calculateVelocityChange(a, t);
        break;
    }
  }

  String _fmt(double val) {
    if (val.isInfinite) return "∞";
    if (val.isNaN) return "NaN";
    if (val == 0) return "0";
    final fixed = val.toStringAsFixed(4);
    if (fixed.contains('.')) {
      final trimmed = fixed.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      return trimmed;
    }
    return fixed;
  }

  void _calculateAcceleration(double? vi, double? vf, double? t) {
    if (vi == null || vf == null || t == null) return;

    if (t <= 0) {
      state = state.copyWith(errorMessage: "Time interval (t) must be strictly positive (> 0).");
      return;
    }

    final accelerationVal = (vf - vi) / t;
    final deltaV = vf - vi;
    final d = (vi * t) + (0.5 * accelerationVal * t * t);

    final steps = [
      "1. Identify the given variables:",
      "   • Initial Velocity (vᵢ) = ${_fmt(vi)} m/s",
      "   • Final Velocity (v_f) = ${_fmt(vf)} m/s",
      "   • Time interval (t) = ${_fmt(t)} s",
      "2. State the definition formula for acceleration:",
      "   • a = (v_f - vᵢ) / t",
      "3. Compute the change in velocity (Δv):",
      "   • Δv = v_f - vᵢ = ${_fmt(vf)} - (${_fmt(vi)}) = ${_fmt(deltaV)} m/s",
      "4. Divide the velocity change by the time interval:",
      "   • a = ${_fmt(deltaV)} / ${_fmt(t)} = ${_fmt(accelerationVal)} m/s²",
      "5. (Bonus) Compute the displacement (d) under constant acceleration:",
      "   • d = vᵢ·t + ½·a·t²",
      "   • d = (${_fmt(vi)} · ${_fmt(t)}) + (0.5 · ${_fmt(accelerationVal)} · ${_fmt(t)}²)",
      "   • d = ${_fmt(vi * t)} + ${_fmt(0.5 * accelerationVal * t * t)} = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: accelerationVal,
      distance: d,
      steps: steps,
    );
  }

  void _calculateInitialVelocity(double? vf, double? a, double? t) {
    if (vf == null || a == null || t == null) return;

    if (t <= 0) {
      state = state.copyWith(errorMessage: "Time interval (t) must be strictly positive (> 0).");
      return;
    }

    final vi = vf - (a * t);
    final deltaV = a * t;
    final d = (vi * t) + (0.5 * a * t * t);

    final steps = [
      "1. Identify the given variables:",
      "   • Final Velocity (v_f) = ${_fmt(vf)} m/s",
      "   • Acceleration (a) = ${_fmt(a)} m/s²",
      "   • Time interval (t) = ${_fmt(t)} s",
      "2. State the kinematic equation for initial velocity:",
      "   • vᵢ = v_f - a·t",
      "3. Compute the total change in velocity (a·t):",
      "   • Δv = a·t = ${_fmt(a)} · ${_fmt(t)} = ${_fmt(deltaV)} m/s",
      "4. Subtract the change in velocity from the final velocity:",
      "   • vᵢ = ${_fmt(vf)} - ${_fmt(deltaV)} = ${_fmt(vi)} m/s",
      "5. (Bonus) Compute the displacement (d) under constant acceleration:",
      "   • d = vᵢ·t + ½·a·t²",
      "   • d = (${_fmt(vi)} · ${_fmt(t)}) + (0.5 · ${_fmt(a)} · ${_fmt(t)}²)",
      "   • d = ${_fmt(vi * t)} + ${_fmt(0.5 * a * t * t)} = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: vi,
      vInitial: vi,
      distance: d,
      steps: steps,
    );
  }

  void _calculateFinalVelocity(double? vi, double? a, double? t) {
    if (vi == null || a == null || t == null) return;

    if (t <= 0) {
      state = state.copyWith(errorMessage: "Time interval (t) must be strictly positive (> 0).");
      return;
    }

    final vf = vi + (a * t);
    final deltaV = a * t;
    final d = (vi * t) + (0.5 * a * t * t);

    final steps = [
      "1. Identify the given variables:",
      "   • Initial Velocity (vᵢ) = ${_fmt(vi)} m/s",
      "   • Acceleration (a) = ${_fmt(a)} m/s²",
      "   • Time interval (t) = ${_fmt(t)} s",
      "2. State the kinematic equation for final velocity:",
      "   • v_f = vᵢ + a·t",
      "3. Compute the total change in velocity (a·t):",
      "   • Δv = a·t = ${_fmt(a)} · ${_fmt(t)} = ${_fmt(deltaV)} m/s",
      "4. Add the change in velocity to the initial velocity:",
      "   • v_f = ${_fmt(vi)} + ${_fmt(deltaV)} = ${_fmt(vf)} m/s",
      "5. (Bonus) Compute the displacement (d) under constant acceleration:",
      "   • d = vᵢ·t + ½·a·t²",
      "   • d = (${_fmt(vi)} · ${_fmt(t)}) + (0.5 · ${_fmt(a)} · ${_fmt(t)}²)",
      "   • d = ${_fmt(vi * t)} + ${_fmt(0.5 * a * t * t)} = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: vf,
      vFinal: vf,
      distance: d,
      steps: steps,
    );
  }

  void _calculateTime(double? vi, double? vf, double? a) {
    if (vi == null || vf == null || a == null) return;

    if (a == 0) {
      if (vf == vi) {
        state = state.copyWith(
          errorMessage: "Constant velocity (a = 0) cannot uniquely determine time since velocity is unchanging.",
        );
      } else {
        state = state.copyWith(
          errorMessage: "Physically impossible: velocity cannot change from ${_fmt(vi)} to ${_fmt(vf)} with zero acceleration.",
        );
      }
      return;
    }

    final timeVal = (vf - vi) / a;

    if (timeVal < 0) {
      state = state.copyWith(
        errorMessage: "Calculated time is negative (${_fmt(timeVal)} s). Check if the direction of acceleration matches the velocity change.",
      );
      return;
    }

    if (timeVal == 0) {
      state = state.copyWith(
        errorMessage: "Time interval cannot be zero. Check if the initial and final velocities are distinct.",
      );
      return;
    }

    final deltaV = vf - vi;
    final d = (vi * timeVal) + (0.5 * a * timeVal * timeVal);

    final steps = [
      "1. Identify the given variables:",
      "   • Initial Velocity (vᵢ) = ${_fmt(vi)} m/s",
      "   • Final Velocity (v_f) = ${_fmt(vf)} m/s",
      "   • Acceleration (a) = ${_fmt(a)} m/s²",
      "2. State the definition formula rearranged for time:",
      "   • t = (v_f - vᵢ) / a",
      "3. Compute the change in velocity (Δv):",
      "   • Δv = v_f - vᵢ = ${_fmt(vf)} - (${_fmt(vi)}) = ${_fmt(deltaV)} m/s",
      "4. Divide the velocity change by the acceleration:",
      "   • t = ${_fmt(deltaV)} / ${_fmt(a)} = ${_fmt(timeVal)} s",
      "5. (Bonus) Compute the displacement (d) under constant acceleration:",
      "   • d = vᵢ·t + ½·a·t²",
      "   • d = (${_fmt(vi)} · ${_fmt(timeVal)}) + (0.5 · ${_fmt(a)} · ${_fmt(timeVal)}²)",
      "   • d = ${_fmt(vi * timeVal)} + ${_fmt(0.5 * a * timeVal * timeVal)} = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: timeVal,
      time: timeVal,
      distance: d,
      steps: steps,
    );
  }

  void _calculateSimpleAcceleration(double? dv, double? t) {
    if (dv == null || t == null) return;

    if (t <= 0) {
      state = state.copyWith(errorMessage: "Time interval (t) must be strictly positive (> 0).");
      return;
    }

    final accelerationVal = dv / t;
    final d = 0.5 * accelerationVal * t * t;

    final steps = [
      "1. Identify the given variables:",
      "   • Change in Speed (Δv) = ${_fmt(dv)} m/s",
      "   • Time interval (t) = ${_fmt(t)} s",
      "2. State the definition formula for acceleration from speed change:",
      "   • a = Δv / t",
      "3. Divide the change in speed by the time interval:",
      "   • a = ${_fmt(dv)} / ${_fmt(t)} = ${_fmt(accelerationVal)} m/s²",
      "4. (Bonus) Compute the displacement (d) assuming starting from rest (vᵢ = 0):",
      "   • d = ½·a·t²",
      "   • d = 0.5 · ${_fmt(accelerationVal)} · ${_fmt(t)}² = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: accelerationVal,
      acceleration: accelerationVal,
      vInitial: 0.0,
      vFinal: dv,
      distance: d,
      steps: steps,
    );
  }

  void _calculateVelocityChange(double? a, double? t) {
    if (a == null || t == null) return;

    if (t <= 0) {
      state = state.copyWith(errorMessage: "Time interval (t) must be strictly positive (> 0).");
      return;
    }

    final dvVal = a * t;
    final d = 0.5 * a * t * t;

    final steps = [
      "1. Identify the given variables:",
      "   • Acceleration (a) = ${_fmt(a)} m/s²",
      "   • Time interval (t) = ${_fmt(t)} s",
      "2. State the definition formula for velocity change:",
      "   • Δv = a·t",
      "3. Multiply the acceleration by the time interval:",
      "   • Δv = ${_fmt(a)} · ${_fmt(t)} = ${_fmt(dvVal)} m/s",
      "4. (Bonus) Compute the displacement (d) assuming starting from rest (vᵢ = 0):",
      "   • d = ½·a·t²",
      "   • d = 0.5 · ${_fmt(a)} · ${_fmt(t)}² = ${_fmt(d)} m",
    ];

    state = state.copyWith(
      calculatedValue: dvVal,
      speedChange: dvVal,
      vInitial: 0.0,
      vFinal: dvVal,
      distance: d,
      steps: steps,
    );
  }
}
