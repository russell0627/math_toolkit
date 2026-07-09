import 'dart:math' as math;
import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/transformation_sequence_model.dart';

part 'transformation_sequence_ctrl.g.dart';

@riverpod
class TransformationSequenceCtrl extends _$TransformationSequenceCtrl {
  @override
  TransformationSequenceState build() {
    return const TransformationSequenceState();
  }

  void setPoints(List<Offset> newPoints) {
    state = state.copyWith(points: newPoints, isQuickShape: false, lastPreset: null);
    _recalculateResults();
  }

  void addPoint(Offset point) {
    state = state.copyWith(points: [...state.points, point], isQuickShape: false, lastPreset: null);
    _recalculateResults();
  }

  void removePoint(int index) {
    if (index < 0 || index >= state.points.length) return;
    final newPoints = List<Offset>.from(state.points)..removeAt(index);
    state = state.copyWith(points: newPoints, isQuickShape: false, lastPreset: null);
    _recalculateResults();
  }

  void updatePoint(int index, Offset point) {
    if (index < 0 || index >= state.points.length) return;
    final newPoints = List<Offset>.from(state.points);
    newPoints[index] = point;
    state = state.copyWith(points: newPoints, isQuickShape: false, lastPreset: null);
    _recalculateResults();
  }

  void selectStep(int? index) {
    state = state.copyWith(selectedStepIndex: index);
  }

  void generateShape(double width, double height, {bool isCentered = true}) {
    List<Offset> newPoints;
    if (isCentered) {
      final w2 = width / 2;
      final h2 = height / 2;
      newPoints = [
        Offset(-w2, -h2),
        Offset(w2, -h2),
        Offset(w2, h2),
        Offset(-w2, h2),
      ];
    } else {
      newPoints = [
        const Offset(0, 0),
        Offset(width, 0),
        Offset(width, height),
        Offset(0, height),
      ];
    }

    state = state.copyWith(points: newPoints, isQuickShape: true, lastPreset: null);
    _recalculateResults();
  }

  void generatePresetShape(ShapePreset preset, {double size = 4.0}) {
    List<Offset> newPoints = [];

    switch (preset) {
      case ShapePreset.triangle:
        newPoints = [
          const Offset(0, 2),
          const Offset(-1.73, -1),
          const Offset(1.73, -1),
        ];
      case ShapePreset.square:
        final s2 = size / 2;
        newPoints = [
          Offset(-s2, s2),
          Offset(s2, s2),
          Offset(s2, -s2),
          Offset(-s2, -s2),
        ];
      case ShapePreset.pentagon:
        newPoints = _generateRegularPolygon(5, size / 2);
      case ShapePreset.hexagon:
        newPoints = _generateRegularPolygon(6, size / 2);
      case ShapePreset.star:
        newPoints = _generateStar(size / 2, size / 5);
      case ShapePreset.arrow:
        newPoints = [
          const Offset(0, 2),
          const Offset(1.5, 0),
          const Offset(0.7, 0),
          const Offset(0.7, -2),
          const Offset(-0.7, -2),
          const Offset(-0.7, 0),
          const Offset(-1.5, 0),
        ];
      case ShapePreset.house:
        newPoints = [
          const Offset(0, 3),
          const Offset(2, 1),
          const Offset(2, -2),
          const Offset(-2, -2),
          const Offset(-2, 1),
        ];
      case ShapePreset.diamond:
        final s2 = size / 2;
        newPoints = [
          Offset(0, s2),
          Offset(s2, 0),
          Offset(0, -s2),
          Offset(-s2, 0),
        ];
    }

    state = state.copyWith(points: newPoints, isQuickShape: true, lastPreset: preset);
    _recalculateResults();
  }

  List<Offset> _generateRegularPolygon(int sides, double radius) {
    final List<Offset> points = [];
    for (int i = 0; i < sides; i++) {
      final angle = (i * 2 * math.pi / sides) - math.pi / 2;
      points.add(Offset(radius * math.cos(angle), -radius * math.sin(angle)));
    }
    return points;
  }

  List<Offset> _generateStar(double outerRadius, double innerRadius) {
    final List<Offset> points = [];
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi / 5) - math.pi / 2;
      final r = i.isEven ? outerRadius : innerRadius;
      points.add(Offset(r * math.cos(angle), -r * math.sin(angle)));
    }
    return points;
  }

  void addTransformation(
    TransformationType type, {
    int? h,
    int? k,
    double? scale,
    double? centerX,
    double? centerY,
  }) {
    final currentPoints = state.steps.isEmpty ? state.points : state.steps.last.pointResults;

    final expr = _applyTransformExpr(type, scale: scale, centerX: centerX, centerY: centerY, h: h, k: k);
    final results = currentPoints
        .map((p) => _applyTransformOffset(p, type, h: h, k: k, scale: scale, centerX: centerX, centerY: centerY))
        .toList();

    final step = TransformationStep(
      type: type,
      expressionX: expr.x,
      expressionY: expr.y,
      pointResults: results,
      h: h,
      k: k,
      scale: scale,
      centerX: centerX,
      centerY: centerY,
    );

    state = state.copyWith(steps: [...state.steps, step]);
  }

  void _recalculateResults() {
    if (state.steps.isEmpty) return;

    final List<TransformationStep> updatedSteps = [];
    List<Offset> currentResults = state.points;

    for (final step in state.steps) {
      final nextResults = currentResults
          .map(
            (p) => _applyTransformOffset(
              p,
              step.type,
              h: step.h,
              k: step.k,
              scale: step.scale,
              centerX: step.centerX,
              centerY: step.centerY,
            ),
          )
          .toList();
      updatedSteps.add(step.copyWith(pointResults: nextResults));
      currentResults = nextResults;
    }

    state = state.copyWith(steps: updatedSteps);
  }

  void removeStep(int index) {
    if (index < 0 || index >= state.steps.length) return;
    final newSteps = List<TransformationStep>.from(state.steps)..removeAt(index);
    state = state.copyWith(steps: newSteps);
    _recalculateResults();
  }

  void reset() {
    state = const TransformationSequenceState();
  }

  Offset _applyTransformOffset(
    Offset p,
    TransformationType type, {
    int? h,
    int? k,
    double? scale,
    double? centerX,
    double? centerY,
  }) {
    final cx = centerX ?? 0.0;
    final cy = centerY ?? 0.0;

    // Translate to local space if center is provided
    final localP = Offset(p.dx - cx, p.dy - cy);

    final transformedLocal = switch (type) {
      TransformationType.reflectX => Offset(localP.dx, -localP.dy),
      TransformationType.reflectY => Offset(-localP.dx, localP.dy),
      TransformationType.reflectOrigin => Offset(-localP.dx, -localP.dy),
      TransformationType.rotate90CCW => Offset(-localP.dy, localP.dx),
      TransformationType.rotate90CW => Offset(localP.dy, -localP.dx),
      TransformationType.rotate180 => Offset(-localP.dx, -localP.dy),
      TransformationType.rotate270CCW => Offset(localP.dy, -localP.dx),
      TransformationType.rotate270CW => Offset(-localP.dy, localP.dx),
      TransformationType.translate => Offset(localP.dx + (h ?? 0), localP.dy + (k ?? 0)),
      TransformationType.dilate => Offset(localP.dx * (scale ?? 1.0), localP.dy * (scale ?? 1.0)),
    };

    // Translate back to global space
    return Offset(transformedLocal.dx + cx, transformedLocal.dy + cy);
  }

  ({String x, String y}) _applyTransformExpr(
    TransformationType type, {
    int? h,
    int? k,
    double? scale,
    double? centerX,
    double? centerY,
  }) {
    final sH = h?.toString() ?? "0";
    final sK = k?.toString() ?? "0";
    final sS = scale?.toString() ?? "1";
    final cx = centerX ?? 0.0;
    final cy = centerY ?? 0.0;

    // Base expressions adjusted for center
    final adjX = cx == 0 ? "x" : "(x - $cx)";
    final adjY = cy == 0 ? "y" : "(y - $cy)";
    final revX = cx == 0 ? "" : " + $cx";
    final revY = cy == 0 ? "" : " + $cy";

    return switch (type) {
      TransformationType.reflectX => (x: "$adjX$revX", y: "-$adjY$revY"),
      TransformationType.reflectY => (x: "-$adjX$revX", y: "$adjY$revY"),
      TransformationType.reflectOrigin => (x: "-$adjX$revX", y: "-$adjY$revY"),
      TransformationType.rotate90CCW => (x: "-$adjY$revX", y: "$adjX$revY"),
      TransformationType.rotate90CW => (x: "$adjY$revX", y: "-$adjX$revY"),
      TransformationType.rotate180 => (x: "-$adjX$revX", y: "-$adjY$revY"),
      TransformationType.rotate270CCW => (x: "$adjY$revX", y: "-$adjX$revY"),
      TransformationType.rotate270CW => (x: "-$adjY$revX", y: "$adjX$revY"),
      TransformationType.translate => (x: "x + $sH", y: "y + $sK"),
      TransformationType.dilate => (x: "$sS$adjX$revX", y: "$sS$adjY$revY"),
    };
  }
}
