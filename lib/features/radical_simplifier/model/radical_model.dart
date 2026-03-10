import 'package:dart_mappable/dart_mappable.dart';

part 'radical_model.mapper.dart';

@MappableClass()
class RadicalState with RadicalStateMappable {
  final int? inputRadicand;
  final int coefficient;
  final int radicand;
  final double? decimalValue;
  final int? lowerBound;
  final int? upperBound;

  const RadicalState({
    this.inputRadicand,
    this.coefficient = 1,
    this.radicand = 1,
    this.decimalValue,
    this.lowerBound,
    this.upperBound,
  });

  String get displayResult {
    if (inputRadicand == null) return "";
    if (radicand == 1) return coefficient.toString();
    if (coefficient == 1) return "√$radicand";
    return "$coefficient√$radicand";
  }

  String get estimationRange {
    if (lowerBound == null || upperBound == null) return "";
    final l2 = lowerBound! * lowerBound!;
    final u2 = upperBound! * upperBound!;
    return "√$l2 < √$inputRadicand < √$u2\n ($lowerBound)     (≈${decimalValue?.toStringAsFixed(2)})     ($upperBound)";
  }

  bool get isPerfectSquare => radicand == 1 && inputRadicand != null;
  bool get isEmpty => inputRadicand == null;
}
