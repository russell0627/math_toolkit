import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/triangle_model.dart';

part 'triangle_solver_ctrl.g.dart';

@riverpod
class TriangleSolverCtrl extends _$TriangleSolverCtrl {
  @override
  TriangleState build() {
    return const TriangleState();
  }

  void setType(TriangleType type) {
    state = state.copyWith(type: type);
    _realign();
  }

  void updateAngleA(double? val) => _update(angleA: val, isUserA: val != null);
  void updateAngleB(double? val) => _update(angleB: val, isUserB: val != null);
  void updateAngleC(double? val) => _update(angleC: val, isUserC: val != null);
  void updateExtA(double? val) => _update(extA: val, isUserExtA: val != null);
  void updateExtB(double? val) => _update(extB: val, isUserExtB: val != null);
  void updateExtC(double? val) => _update(extC: val, isUserExtC: val != null);

  void _update({
    double? angleA,
    double? angleB,
    double? angleC,
    double? extA,
    double? extB,
    double? extC,
    bool? isUserA,
    bool? isUserB,
    bool? isUserC,
    bool? isUserExtA,
    bool? isUserExtB,
    bool? isUserExtC,
  }) {
    state = state.copyWith(
      angleA: isUserA != null ? angleA : state.angleA,
      angleB: isUserB != null ? angleB : state.angleB,
      angleC: isUserC != null ? angleC : state.angleC,
      extA: isUserExtA != null ? extA : state.extA,
      extB: isUserExtB != null ? extB : state.extB,
      extC: isUserExtC != null ? extC : state.extC,
      isUserA: isUserA ?? state.isUserA,
      isUserB: isUserB ?? state.isUserB,
      isUserC: isUserC ?? state.isUserC,
      isUserExtA: isUserExtA ?? state.isUserExtA,
      isUserExtB: isUserExtB ?? state.isUserExtB,
      isUserExtC: isUserExtC ?? state.isUserExtC,
    );
    _realign();
  }

  void _realign() {
    var s = state;

    // 1. Reset all non-user fields to null before recalculating
    s = s.copyWith(
      angleA: s.isUserA ? s.angleA : null,
      angleB: s.isUserB ? s.angleB : null,
      angleC: s.isUserC ? s.angleC : null,
      extA: s.isUserExtA ? s.extA : null,
      extB: s.isUserExtB ? s.extB : null,
      extC: s.isUserExtC ? s.extC : null,
    );

    // 2. Iterative Cascade
    for (int i = 0; i < 3; i++) {
      // Sync pairs (if one is user-set, set the other as derived)
      if (s.angleA != null && s.extA == null) s = s.copyWith(extA: 180 - s.angleA!);
      if (s.extA != null && s.angleA == null) s = s.copyWith(angleA: 180 - s.extA!);
      if (s.angleB != null && s.extB == null) s = s.copyWith(extB: 180 - s.angleB!);
      if (s.extB != null && s.angleB == null) s = s.copyWith(angleB: 180 - s.extB!);
      if (s.angleC != null && s.extC == null) s = s.copyWith(extC: 180 - s.angleC!);
      if (s.extC != null && s.angleC == null) s = s.copyWith(angleC: 180 - s.extC!);

      // Templates (Apply only to null fields)
      if (s.type == TriangleType.equilateral) {
        if (s.angleA == null) s = s.copyWith(angleA: 60);
        if (s.angleB == null) s = s.copyWith(angleB: 60);
        if (s.angleC == null) s = s.copyWith(angleC: 60);
      } else if (s.type == TriangleType.rightA && s.angleA == null) {
        s = s.copyWith(angleA: 90);
      } else if (s.type == TriangleType.rightB && s.angleB == null) {
        s = s.copyWith(angleB: 90);
      } else if (s.type == TriangleType.rightC && s.angleC == null) {
        s = s.copyWith(angleC: 90);
      }

      // Isosceles Constraints
      if (s.type == TriangleType.isoscelesA) {
        if (s.angleA != null) {
          final b = (180 - s.angleA!) / 2;
          if (s.angleB == null) s = s.copyWith(angleB: b);
          if (s.angleC == null) s = s.copyWith(angleC: b);
        } else if (s.angleB != null) {
          if (s.angleC == null) s = s.copyWith(angleC: s.angleB);
          if (s.angleA == null) s = s.copyWith(angleA: 180 - (s.angleB! * 2));
        } else if (s.angleC != null) {
          if (s.angleB == null) s = s.copyWith(angleB: s.angleC);
          if (s.angleA == null) s = s.copyWith(angleA: 180 - (s.angleC! * 2));
        }
      } else if (s.type == TriangleType.isoscelesB) {
        if (s.angleB != null) {
          final b = (180 - s.angleB!) / 2;
          if (s.angleA == null) s = s.copyWith(angleA: b);
          if (s.angleC == null) s = s.copyWith(angleC: b);
        } else if (s.angleA != null) {
          if (s.angleC == null) s = s.copyWith(angleC: s.angleA);
          if (s.angleB == null) s = s.copyWith(angleB: 180 - (s.angleA! * 2));
        } else if (s.angleC != null) {
          if (s.angleA == null) s = s.copyWith(angleA: s.angleC);
          if (s.angleB == null) s = s.copyWith(angleB: 180 - (s.angleC! * 2));
        }
      } else if (s.type == TriangleType.isoscelesC) {
        if (s.angleC != null) {
          final b = (180 - s.angleC!) / 2;
          if (s.angleA == null) s = s.copyWith(angleA: b);
          if (s.angleB == null) s = s.copyWith(angleB: b);
        } else if (s.angleA != null) {
          if (s.angleB == null) s = s.copyWith(angleB: s.angleA);
          if (s.angleC == null) s = s.copyWith(angleC: 180 - (s.angleA! * 2));
        } else if (s.angleB != null) {
          if (s.angleA == null) s = s.copyWith(angleA: s.angleB);
          if (s.angleC == null) s = s.copyWith(angleC: 180 - (s.angleB! * 2));
        }
      }

      // Interior Sum Resolution (Fill if 1 is empty)
      final known = [s.angleA, s.angleB, s.angleC].where((a) => a != null).length;
      if (known == 2) {
        if (s.angleA == null) s = s.copyWith(angleA: 180 - (s.angleB! + s.angleC!));
        if (s.angleB == null) s = s.copyWith(angleB: 180 - (s.angleA! + s.angleC!));
        if (s.angleC == null) s = s.copyWith(angleC: 180 - (s.angleA! + s.angleB!));
      }
    }

    state = s;
  }

  void reset() {
    state = const TriangleState();
  }
}
