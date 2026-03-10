import 'package:dart_mappable/dart_mappable.dart';

part 'triangle_model.mapper.dart';

enum TriangleType {
  none("SCALENE"),
  isoscelesA("ISO-A (Vertex)"),
  isoscelesB("ISO-B (Vertex)"),
  isoscelesC("ISO-C (Vertex)"),
  equilateral("EQUILATERAL"),
  rightA("RIGHT-A (90°)"),
  rightB("RIGHT-B (90°)"),
  rightC("RIGHT-C (90°)")
  ;

  final String label;
  const TriangleType(this.label);
}

@MappableClass()
class TriangleState with TriangleStateMappable {
  final double? angleA;
  final double? angleB;
  final double? angleC;
  final double? extA;
  final double? extB;
  final double? extC;

  final bool isUserA;
  final bool isUserB;
  final bool isUserC;
  final bool isUserExtA;
  final bool isUserExtB;
  final bool isUserExtC;

  final TriangleType type;

  const TriangleState({
    this.angleA,
    this.angleB,
    this.angleC,
    this.extA,
    this.extB,
    this.extC,
    this.isUserA = false,
    this.isUserB = false,
    this.isUserC = false,
    this.isUserExtA = false,
    this.isUserExtB = false,
    this.isUserExtC = false,
    this.type = TriangleType.none,
  });

  bool get isFullInterior => angleA != null && angleB != null && angleC != null;

  bool get areAllPositive =>
      (angleA == null || angleA! > 0) && (angleB == null || angleB! > 0) && (angleC == null || angleC! > 0);

  double get interiorSum => (angleA ?? 0) + (angleB ?? 0) + (angleC ?? 0);

  bool get isValidSum => !isFullInterior || ((interiorSum - 180).abs() < 1e-10 && areAllPositive);
}
