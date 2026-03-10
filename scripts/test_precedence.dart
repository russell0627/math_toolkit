import 'package:math_expressions/math_expressions.dart';

void main() {
  final parser = Parser();
  final cm = ContextModel();
  final v = Variable('b');

  String normalize(String input) {
    var s = input.replaceAll(' ', '').replaceAll(',', '.');
    s = s.replaceAllMapped(RegExp(r'(^|[^0-9])\.(\d)'), (m) => '${m[1]}0.${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(\d+\.?\d*)([a-zA-Z])'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])(\d)'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])([a-zA-Z])'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(\d+\.?\d*)\('), (m) => '${m[1]}*(');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])\('), (m) => '${m[1]}*(');
    s = s.replaceAllMapped(RegExp(r'\)([a-zA-Z])'), (m) => ')*${m[1]}');
    s = s.replaceAllMapped(RegExp(r'\)(\d)'), (m) => ')*${m[1]}');
    s = s.replaceAllMapped(RegExp(r'\)\('), (m) => ')*(');
    return s;
  }

  // Test 5/9 = 4/3b + 2
  final input = "4/3b + 2";
  final normalized = normalize(input);
  print('Input: $input');
  print('Normalized: $normalized');

  final exp = parser.parse(normalized);
  print('Type: ${exp.runtimeType}');
  print('toString: $exp');

  cm.bindVariable(v, Number(0));
  final f0 = exp.evaluate(EvaluationType.REAL, cm);
  cm.bindVariable(v, Number(1));
  final f1 = exp.evaluate(EvaluationType.REAL, cm);
  cm.bindVariable(v, Number(2));
  final f2 = exp.evaluate(EvaluationType.REAL, cm);

  print('f(0): $f0, f(1): $f1, f(2): $f2');

  if ((f1 - f0 - (f2 - f1)).abs() < 1e-10) {
    print('Linear detected.');
    final slope = f1 - f0;
    final intercept = f0;
    print('Slope: $slope, Intercept: $intercept');
  } else {
    print('Not linear.');
  }

  print('\n--- Negative Ratio Test ---');
  final negInput = "-2c/5";
  final negNormalized = normalize(negInput);
  print('Input: $negInput');
  print('Normalized: $negNormalized');
  final negExp = parser.parse(negNormalized);
  print('Type: ${negExp.runtimeType}');
  print('toString: $negExp');

  if (negExp is Divide) {
    print('LHS: ${negExp.first} (${negExp.first.runtimeType})');
    print('RHS: ${negExp.second} (${negExp.second.runtimeType})');
  }

  print('\n--- Squared Variable Test ---');
  final sqInput = "b^2 - 4";
  final sqNormalized = normalize(sqInput);
  print('Input: $sqInput');
  print('Normalized: $sqNormalized');
  final sqExp = parser.parse(sqNormalized);
  print('Type: ${sqExp.runtimeType}');

  final v2 = Variable('b');
  cm.bindVariable(v2, Number(0));
  final s0 = sqExp.evaluate(EvaluationType.REAL, cm);
  cm.bindVariable(v2, Number(1));
  final s1 = sqExp.evaluate(EvaluationType.REAL, cm);
  cm.bindVariable(v2, Number(2));
  final s2 = sqExp.evaluate(EvaluationType.REAL, cm);
  cm.bindVariable(v2, Number(3));
  final s3 = sqExp.evaluate(EvaluationType.REAL, cm);

  final as1 = (s1 - s0);
  final as2 = (s2 - s1);
  final as3 = (s3 - s2);

  final aa1 = as2 - as1;
  final aa2 = as3 - as2;

  print('f(0): $s0, f(1): $s1, f(2): $s2, f(3): $s3');
  print('First diffs: $as1, $as2, $as3');
  print('Second diffs (accel): $aa1, $aa2');

  if ((aa1 - aa2).abs() < 1e-10 && aa1.abs() > 1e-10) {
    print('Quadratic detected!');
    final double c = s0;
    final double a = aa1 / 2;
    final double b = s1 - a - c;
    print('Fit: ${a}b^2 + ${b}b + $c');
  }
  print('\n--- Radical Solve Test ---');
  // x^2 - 8 = 0 => x^2 = 8 => x = +/- sqrt(8) = +/- 2*sqrt(2)
  double a = 1.0, b = 0.0, c = -8.0;
  double D = b * b - 4 * a * c; // 32
  print('a: $a, b: $b, c: $c, D: $D');

  // Simulated _simplifyRadical
  (int, int) simplifyRadical(int n) {
    int factor = 1;
    int radicand = n;
    for (int i = 2; i * i <= radicand; i++) {
      while (radicand % (i * i) == 0) {
        factor *= i;
        radicand ~/= (i * i);
      }
    }
    return (factor, radicand);
  }

  final (factor, radicand) = simplifyRadical(D.round());
  print('Simplified Radical: $factor*sqrt($radicand)');

  // Simulated _formatRadical logic
  String formatPart(bool positive) {
    final double bVal = -b;
    final double fVal = positive ? factor.toDouble() : -factor.toDouble();
    final denom = (2 * a).round();

    if ((bVal % denom).abs() < 1e-10 && (fVal % denom).abs() < 1e-10) {
      final int bFinal = (bVal ~/ denom);
      final int fFinalRaw = (fVal ~/ denom).toInt();
      final int fFinal = fFinalRaw.abs();
      final String sign = positive ? (bFinal == 0 ? "" : " + ") : (bFinal == 0 ? "-" : " - ");

      String res = "";
      if (bFinal != 0) res += bFinal.toString();
      if (fFinal != 1) {
        res += "$sign$fFinal*sqrt($radicand)";
      } else {
        res += "${sign}sqrt($radicand)";
      }
      return res;
    }
    return "(${-b} ${positive ? '+' : '-'} ($factor*sqrt($radicand))) / ${2 * a}";
  }

  print('Roots: ${formatPart(true)}, ${formatPart(false)}');
}
