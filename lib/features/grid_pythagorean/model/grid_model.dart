import 'package:dart_mappable/dart_mappable.dart';

part 'grid_model.mapper.dart';

@MappableClass()
class GridPythagoreanState with GridPythagoreanStateMappable {
  final double? x1;
  final double? y1;
  final double? x2;
  final double? y2;

  const GridPythagoreanState({
    this.x1,
    this.y1,
    this.x2,
    this.y2,
  });

  bool get isComplete => x1 != null && y1 != null && x2 != null && y2 != null;

  double? get dx => (isComplete) ? (x2! - x1!).abs() : null;
  double? get dy => (isComplete) ? (y2! - y1!).abs() : null;

  double? get distance => (dx != null && dy != null)
      ? (dx! * dx! + dy! * dy! != 0)
            ? (x2! - x1!) * (x2! - x1!) + (y2! - y1!) * (y2! - y1!)
            : 0
      : null;

  // We'll calculate the actual sqrt in the UI/ViewModel for display
  double? get distanceValue =>
      (isComplete) ? double.parse(((x2! - x1!) * (x2! - x1!) + (y2! - y1!) * (y2! - y1!)).toStringAsFixed(8)) : null;
}
