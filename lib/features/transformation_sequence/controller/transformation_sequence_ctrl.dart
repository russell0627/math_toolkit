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
    state = state.copyWith(points: newPoints, isQuickShape: false);
    _recalculateResults();
  }

  void addPoint(Offset point) {
    state = state.copyWith(points: [...state.points, point], isQuickShape: false);
    _recalculateResults();
  }

  void removePoint(int index) {
    if (index < 0 || index >= state.points.length) return;
    final newPoints = List<Offset>.from(state.points)..removeAt(index);
    state = state.copyWith(points: newPoints, isQuickShape: false);
    _recalculateResults();
  }

  void updatePoint(int index, Offset point) {
    if (index < 0 || index >= state.points.length) return;
    final newPoints = List<Offset>.from(state.points);
    newPoints[index] = point;
    state = state.copyWith(points: newPoints, isQuickShape: false);
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
    
    state = state.copyWith(points: newPoints, isQuickShape: true);
    _recalculateResults();
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
          .map((p) => _applyTransformOffset(
                p,
                step.type,
                h: step.h,
                k: step.k,
                scale: step.scale,
                centerX: step.centerX,
                centerY: step.centerY,
              ))
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
