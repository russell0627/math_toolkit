import 'package:dart_mappable/dart_mappable.dart';

part 'efficiency_model.mapper.dart';

@MappableClass()
class EfficiencyState with EfficiencyStateMappable {
  final String inputWorkInput;
  final String inputWorkOutput;

  final double? workInput;
  final double? workOutput;

  final double? efficiency;
  final double? loss;
  final List<String> steps;
  final String? errorMessage;

  const EfficiencyState({
    this.inputWorkInput = "",
    this.inputWorkOutput = "",
    this.workInput,
    this.workOutput,
    this.efficiency,
    this.loss,
    this.steps = const [],
    this.errorMessage,
  });

  bool get hasInputs => inputWorkInput.isNotEmpty || inputWorkOutput.isNotEmpty;
  bool get hasResult => efficiency != null && errorMessage == null;
}
