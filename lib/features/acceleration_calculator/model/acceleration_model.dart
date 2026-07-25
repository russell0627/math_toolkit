import 'package:dart_mappable/dart_mappable.dart';

part 'acceleration_model.mapper.dart';

@MappableEnum()
enum AccelerationSolveMode {
  acceleration(label: "Acceleration (a)"),
  initialVelocity(label: "Initial Velocity (vi)"),
  finalVelocity(label: "Final Velocity (vf)"),
  time(label: "Time (t)"),
  speedChange(label: "Speed Change (Δv / t)"),
  velocityChange(label: "Velocity Change (a·t)");

  final String label;
  const AccelerationSolveMode({required this.label});
}

@MappableClass()
class AccelerationState with AccelerationStateMappable {
  final AccelerationSolveMode solveMode;
  final String inputInitialVelocity;
  final String inputFinalVelocity;
  final String inputTime;
  final String inputAcceleration;
  final String inputSpeedChange;

  final double? vInitial;
  final double? vFinal;
  final double? time;
  final double? acceleration;
  final double? speedChange;

  final double? calculatedValue;
  final double? distance;
  final List<String> steps;
  final String? errorMessage;

  const AccelerationState({
    this.solveMode = AccelerationSolveMode.acceleration,
    this.inputInitialVelocity = "",
    this.inputFinalVelocity = "",
    this.inputTime = "",
    this.inputAcceleration = "",
    this.inputSpeedChange = "",
    this.vInitial,
    this.vFinal,
    this.time,
    this.acceleration,
    this.speedChange,
    this.calculatedValue,
    this.distance,
    this.steps = const [],
    this.errorMessage,
  });

  bool get hasInputs =>
      inputInitialVelocity.isNotEmpty ||
      inputFinalVelocity.isNotEmpty ||
      inputTime.isNotEmpty ||
      inputAcceleration.isNotEmpty ||
      inputSpeedChange.isNotEmpty;

  bool get hasResult => calculatedValue != null && errorMessage == null;
}
