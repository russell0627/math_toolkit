import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../utils/math_utils.dart';
import '../model/radical_model.dart';

part 'radical_ctrl.g.dart';

@riverpod
class RadicalCtrl extends _$RadicalCtrl {
  final Parser _parser = Parser();

  @override
  RadicalState build() {
    return const RadicalState();
  }

  void simplify(String input) {
    if (input.trim().isEmpty) {
      state = const RadicalState();
      return;
    }

    try {
      final normalized = input.replaceAll('√', 'sqrt').replaceAll(' ', '');
      final exp = _parser.parse(normalized);
      final val = exp.evaluate(EvaluationType.REAL, ContextModel());

      final int n = val.round();
      if (n < 0) {
        state = const RadicalState();
        return;
      }

      final (coef, rad) = MathUtils.simplifyRadical(n);

      // Calculate estimation bounds
      final root = math.sqrt(n);
      final lower = root.floor();
      final upper = root.ceil();

      state = RadicalState(
        inputRadicand: n,
        coefficient: coef,
        radicand: rad,
        decimalValue: val,
        lowerBound: lower,
        upperBound: upper == lower
            ? upper + 1
            : upper, // If perfect square, we usually show the distance to next squares
      );

      // Actually, if it's a perfect square, the user probably doesn't need a range.
      // But for "estimation", usually we show 7 < √50 < 8.
      // If n=49, it's just 7.
      // Let's refine the model/UI to only show the range if NOT a perfect square.
      if (upper == lower) {
        state = state.copyWith(
          lowerBound: lower - 1,
          upperBound: upper + 1,
        );
      }
    } catch (e) {
      state = const RadicalState();
    }
  }

  void reset() {
    state = const RadicalState();
  }
}
