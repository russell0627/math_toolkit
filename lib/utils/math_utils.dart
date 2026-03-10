import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class MathUtils {
  /// Simplifies a square root into its simplest radical form (coefficient * sqrt(radicand)).
  /// Returns a record (coefficient, radicand).
  static (int, int) simplifyRadical(int n) {
    if (n < 0) return (0, 0); // Invalid for real radicals
    if (n == 0) return (0, 1);

    int coef = 1;
    int rad = n;
    int divisor = 2;

    while (divisor * divisor <= rad) {
      if (rad % (divisor * divisor) == 0) {
        coef *= divisor;
        rad ~/= (divisor * divisor);
      } else {
        divisor++;
      }
    }

    return (coef, rad);
  }

  /// Formats a coefficient and radicand as a radical string (e.g., "2√3").
  static String formatRadical(int coef, int rad) {
    if (rad == 1) return coef.toString();
    if (coef == 1) return "√$rad";
    if (coef == 0) return "0";
    return "$coef√$rad";
  }

  /// Attempts to find a radical representation for a double value.
  /// Returns the radical string if the square of the value is approximately an integer,
  /// otherwise returns null.
  static String? tryFormatAsRadical(double value, {double tolerance = 1e-9}) {
    if (value < 0) return null;

    final squared = value * value;
    final nearestInt = squared.round();

    if ((squared - nearestInt).abs() < tolerance && nearestInt > 0) {
      final (coef, rad) = simplifyRadical(nearestInt);
      // Double check that the simplified radical actually matches the value
      final radicalVal = coef * math.sqrt(rad);
      if ((radicalVal - value).abs() < tolerance) {
        return formatRadical(coef, rad);
      }
    }

    return null;
  }

  /// Evaluates a mathematical expression string, handling radicals and decimals.
  static double? evaluateExpression(String input) {
    if (input.isEmpty) return null;
    try {
      final normalized = input.replaceAll('√', 'sqrt').replaceAll(' ', '');
      final p = Parser();
      final exp = p.parse(normalized);
      return exp.evaluate(EvaluationType.REAL, ContextModel()) as double;
    } catch (e) {
      return double.tryParse(input);
    }
  }
}
