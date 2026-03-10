import 'dart:ui';
import 'package:dart_mappable/dart_mappable.dart';

part 'transformation_sequence_model.mapper.dart';

@MappableEnum()
enum TransformationType {
  reflectX('REFLECT X-AXIS'),
  reflectY('REFLECT Y-AXIS'),
  reflectOrigin('REFLECT ORIGIN'),
  rotate90CCW('ROTATE 90° CCW'),
  rotate90CW('ROTATE 90° CW'),
  rotate180('ROTATE 180°'),
  rotate270CCW('ROTATE 270° CCW'),
  rotate270CW('ROTATE 270° CW'),
  translate('TRANSLATE (h, k)'),
  dilate('DILATE (k)');

  final String label;
  const TransformationType(this.label);
}

@MappableClass()
class TransformationStep with TransformationStepMappable {
  final TransformationType type;
  final String expressionX;
  final String expressionY;
  final List<Offset> pointResults;
  final int? h;
  final int? k;
  final double? scale;
  final double? centerX;
  final double? centerY;

  const TransformationStep({
    required this.type,
    required this.expressionX,
    required this.expressionY,
    this.pointResults = const [],
    this.h,
    this.k,
    this.scale,
    this.centerX,
    this.centerY,
  });
}

@MappableClass()
class TransformationSequenceState with TransformationSequenceStateMappable {
  final List<TransformationStep> steps;
  final List<Offset> points;
  final int? selectedStepIndex;

  const TransformationSequenceState({
    this.steps = const [],
    this.points = const [Offset(2, 2), Offset(5, 2), Offset(2, 5)], // Default triangle
    this.selectedStepIndex,
  });

  bool get hasPoints => points.isNotEmpty;
}
