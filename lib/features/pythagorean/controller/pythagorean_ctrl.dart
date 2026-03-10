import 'dart:math' as math;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/math_utils.dart';
import '../model/pythagorean_model.dart';

part 'pythagorean_ctrl.g.dart';

@riverpod
class PythagoreanCtrl extends _$PythagoreanCtrl {
  @override
  PythagoreanState build() {
    return const PythagoreanState();
  }

  void updateSideA(String val) => _update(sideA: _evaluate(val), isUserA: val.isNotEmpty);
  void updateSideB(String val) => _update(sideB: _evaluate(val), isUserB: val.isNotEmpty);
  void updateSideC(String val) => _update(sideC: _evaluate(val), isUserC: val.isNotEmpty);

  double? _evaluate(String input) => MathUtils.evaluateExpression(input);

  void _update({
    double? sideA,
    double? sideB,
    double? sideC,
    bool? isUserA,
    bool? isUserB,
    bool? isUserC,
  }) {
    state = state.copyWith(
      sideA: isUserA != null ? sideA : state.sideA,
      sideB: isUserB != null ? sideB : state.sideB,
      sideC: isUserC != null ? sideC : state.sideC,
      isUserA: isUserA ?? state.isUserA,
      isUserB: isUserB ?? state.isUserB,
      isUserC: isUserC ?? state.isUserC,
    );
    _realign();
  }

  void _realign() {
    var s = state;

    // Reset non-user fields to null before recalculating
    s = s.copyWith(
      sideA: s.isUserA ? s.sideA : null,
      sideB: s.isUserB ? s.sideB : null,
      sideC: s.isUserC ? s.sideC : null,
    );

    // Solve for missing sides if exactly 2 are known
    final knownCount = [s.sideA, s.sideB, s.sideC].where((side) => side != null).length;

    double? solvedVal;
    if (knownCount == 2) {
      if (s.sideA != null && s.sideB != null && s.sideC == null) {
        solvedVal = math.sqrt(math.pow(s.sideA!, 2) + math.pow(s.sideB!, 2));
        s = s.copyWith(sideC: solvedVal);
      } else if (s.sideA != null && s.sideC != null && s.sideB == null) {
        final diff = math.pow(s.sideC!, 2) - math.pow(s.sideA!, 2);
        solvedVal = diff > 0 ? math.sqrt(diff) : 0;
        s = s.copyWith(sideB: solvedVal);
      } else if (s.sideB != null && s.sideC != null && s.sideA == null) {
        final diff = math.pow(s.sideC!, 2) - math.pow(s.sideB!, 2);
        solvedVal = diff > 0 ? math.sqrt(diff) : 0;
        s = s.copyWith(sideA: solvedVal);
      }
    }

    if (solvedVal != null) {
      final n = (solvedVal * solvedVal).round();
      final r = math.sqrt(n.toDouble());
      int lower = r.floor();
      int upper = r.ceil();
      if (lower == upper) {
        s = s.copyWith(lowerBound: null, upperBound: null);
      } else {
        s = s.copyWith(lowerBound: lower, upperBound: upper);
      }
    } else {
      s = s.copyWith(lowerBound: null, upperBound: null);
    }

    state = s;
  }

  void reset() {
    state = const PythagoreanState();
  }
}
