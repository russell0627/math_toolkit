import 'package:dart_mappable/dart_mappable.dart';

part 'pythagorean_model.mapper.dart';

@MappableClass()
class PythagoreanState with PythagoreanStateMappable {
  final double? sideA;
  final double? sideB;
  final double? sideC;

  final bool isUserA;
  final bool isUserB;
  final bool isUserC;

  final int? lowerBound;
  final int? upperBound;

  const PythagoreanState({
    this.sideA,
    this.sideB,
    this.sideC,
    this.isUserA = false,
    this.isUserB = false,
    this.isUserC = false,
    this.lowerBound,
    this.upperBound,
  });

  String get estimationRange {
    if (lowerBound == null || upperBound == null) return "";
    double? calculatedVal;
    if (!isUserA) {
      calculatedVal = sideA;
    } else if (!isUserB) {
      calculatedVal = sideB;
    } else if (!isUserC) {
      calculatedVal = sideC;
    }

    if (calculatedVal == null) return "";
    final squared = (calculatedVal * calculatedVal).round();
    return "$lowerBound < √$squared < $upperBound";
  }

  bool get isFull => sideA != null && sideB != null && sideC != null;

  bool get isValidAlignment {
    if (!isFull) return true;
    final a2 = sideA! * sideA!;
    final b2 = sideB! * sideB!;
    final c2 = sideC! * sideC!;
    return (a2 + b2 - c2).abs() < 1e-8;
  }

  double? get solvedSideValue {
    if (sideA != null && !isUserA) return sideA;
    if (sideB != null && !isUserB) return sideB;
    if (sideC != null && !isUserC) return sideC;
    return null;
  }

  bool get isPerfectSquareResult => lowerBound == null && solvedSideValue != null;
}
