import 'dart:math' as math;
import 'dart:developer' as developer;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../../utils/math_utils.dart';
import '../model/slope_model.dart';

part 'slope_ctrl.g.dart';

@riverpod
class SlopeCtrl extends _$SlopeCtrl {
  @override
  SlopeState build() {
    return const SlopeState();
  }

  void addPoint(double x, double y) {
    final points = [...state.points, SlopePoint(x: x, y: y)];
    state = state.copyWith(points: points);
    _calculateSlope();
  }

  void removePoint(int index) {
    if (index < 0 || index >= state.points.length) return;
    final points = List<SlopePoint>.from(state.points)..removeAt(index);
    state = state.copyWith(points: points);
    _calculateSlope();
  }

  void clear() {
    state = const SlopeState();
  }

  void _calculateSlope() {
    final points = state.points;
    final n = points.length;
    if (n < 2) {
      state = state.copyWith(
        slope: null,
        yIntercept: null,
        equation: null,
        rise: null,
        run: null,
        distance: null,
        segmentDistances: [],
        segmentRises: [],
        segmentRuns: [],
        segmentSlopes: [],
      );
      return;
    }

    double sumX = 0;
    double sumY = 0;
    double sumXY = 0;
    double sumX2 = 0;

    for (final p in points) {
      sumX += p.x;
      sumY += p.y;
      sumXY += p.x * p.y;
      sumX2 += p.x * p.x;
    }

    final denominator = (n * sumX2) - (sumX * sumX);

    // Calculate Segment Metrics based on ENTRY ORDER
    final List<double> segmentDists = [];
    final List<double> segmentRis = [];
    final List<double> segmentRun = [];
    final List<double> segmentSlp = [];
    final List<String> segmentSlpFractions = [];

    for (int i = 0; i < n - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final dx = p2.x - p1.x;
      final dy = p2.y - p1.y;
      final dist = math.sqrt(dx * dx + dy * dy);
      final slp = dx != 0 ? dy / dx : double.infinity;

      segmentDists.add(dist);
      segmentRis.add(dy);
      segmentRun.add(dx);
      segmentSlp.add(slp);
      segmentSlpFractions.add(MathUtils.toFraction(slp));
    }

    if (denominator.abs() < 1e-10) {
      // Handle vertical line
      final minY = points.map((p) => p.y).reduce(math.min);
      final maxY = points.map((p) => p.y).reduce(math.max);
      final totalRise = maxY - minY;

      state = state.copyWith(
        points: points,
        slope: double.infinity,
        yIntercept: null,
        equation: 'x = ${points[0].x.toStringAsFixed(2)}',
        rise: totalRise,
        run: 0.00,
        distance: totalRise,
        segmentDistances: segmentDists,
        segmentRises: segmentRis,
        segmentRuns: segmentRun,
        segmentSlopes: segmentSlp,
        slopeFraction: "∞",
        segmentSlopesFractions: segmentSlpFractions,
      );
      if (state.secondSlope != null) {
        _calculateIntersection();
      }
      return;
    }

    final m = (n * sumXY - sumX * sumY) / denominator;
    final b = (sumY - m * sumX) / n;

    final minX = points.map((p) => p.x).reduce(math.min);
    final maxX = points.map((p) => p.x).reduce(math.max);
    final totalRun = maxX - minX;
    final totalRise = m * totalRun;
    final totalDist = math.sqrt(totalRun * totalRun + totalRise * totalRise);

    final mFrac = MathUtils.toFraction(m);
    final bStr = b.abs().toStringAsFixed(2);
    final sign = b >= 0 ? '+' : '-';

    // Use fraction in equation if not a whole number
    final equationSlope = m.abs() == m.roundToDouble() ? m.toStringAsFixed(0) : "($mFrac)";
    final equation = 'y = ${equationSlope}x $sign $bStr';

    // Linearity Check: All segment slopes must match the regression slope (m)
    bool isPerfectlyLinear = true;
    const tolerance = 1e-10;
    for (final s in segmentSlp) {
      if (s == double.infinity) {
        // Handled in separate branch if all are vertical
      } else if ((s - m).abs() > tolerance) {
        isPerfectlyLinear = false;
        break;
      }
    }

    state = state.copyWith(
      points: points,
      slope: m,
      yIntercept: b,
      equation: equation,
      rise: totalRise,
      run: totalRun,
      distance: totalDist,
      segmentDistances: segmentDists,
      segmentRises: segmentRis,
      segmentRuns: segmentRun,
      segmentSlopes: segmentSlp,
      slopeFraction: mFrac,
      segmentSlopesFractions: segmentSlpFractions,
      isPerfectlyLinear: isPerfectlyLinear || points.length < 3,
    );
    _auditProportionality();
    if (state.secondSlope != null) {
      _calculateIntersection();
    }
  }

  void setEquation(String raw) {
    if (!raw.contains('=')) return;

    try {
      final parts = raw.split('=');
      final yLabel = parts[0].trim();
      final rhs = parts[1].trim();

      final normRhs = _normalize(rhs);
      final parser = Parser();
      final exp = parser.parse(normRhs);

      // We'll use a hacky Regex for variable discovery or assume first alpha word that isn't a function
      final varRegex = RegExp(r'\b([a-zA-Z][a-zA-Z0-9]*)\b');
      final matches = varRegex.allMatches(normRhs).map((m) => m.group(0)!).toList();
      final functions = {
        'sin',
        'cos',
        'tan',
        'asin',
        'acos',
        'atan',
        'ln',
        'log',
        'sqrt',
        'abs',
        'ceil',
        'floor',
        'round',
      };
      final xLabel = matches.firstWhere((m) => !functions.contains(m), orElse: () => 'x');

      final context = ContextModel();

      double eval(double val) {
        context.bindVariable(Variable(xLabel), Number(val));
        return exp.evaluate(EvaluationType.REAL, context) as double;
      }

      // Generate representative points for the grid/audit
      final generatedPoints = <SlopePoint>[];
      for (double x in [-10, -5, 0, 5, 10]) {
        generatedPoints.add(SlopePoint(x: x, y: eval(x)));
      }

      state = state.copyWith(
        points: generatedPoints,
        xLabel: xLabel,
        yLabel: yLabel,
        inputEquation: raw,
      );

      _calculateSlope();
    } catch (e, s) {
      developer.log('Failed to parse equation', name: 'slope.ctrl', error: e, stackTrace: s);
      // In a real app, we'd propagate this error to the UI
    }
  }

  void _auditProportionality() {
    final points = state.points;
    if (points.isEmpty) return;

    bool isProportional = true;
    double? k;
    final List<double?> ratios = [];
    const tolerance = 1e-10;

    for (final p in points) {
      if (p.x.abs() < tolerance) {
        ratios.add(null);
        if (p.y.abs() > tolerance) {
          isProportional = false;
        }
      } else {
        final currentRatio = p.y / p.x;
        ratios.add(currentRatio);

        if (k == null) {
          k = currentRatio;
        } else {
          if ((currentRatio - k).abs() > tolerance) {
            isProportional = false;
          }
        }
      }
    }

    // A single point (0,0) isn't enough to define proportionality for a "relationship"
    // but the user might expect it to work for even 1 non-zero point.
    // If all points are (0,0), it's technically proportional (k can be anything, but we'll say 0).
    if (k == null && isProportional) k = 0;

    state = state.copyWith(
      isProportional: isProportional && points.isNotEmpty,
      proportionalityConstant: isProportional ? k : null,
      proportionalityFraction: isProportional && k != null ? MathUtils.toFraction(k) : null,
      pointRatios: ratios,
    );
  }

  void toggleMinimalMode() {
    state = state.copyWith(isMinimalMode: !state.isMinimalMode);
  }

  void setSecondLine(double slope, double intercept) {
    state = state.copyWith(
      secondSlope: slope,
      secondYIntercept: intercept,
      secondEquation: slope == double.infinity
          ? 'x = ${intercept.toStringAsFixed(2)}'
          : 'y = ${slope.abs() == slope.roundToDouble() ? slope.toStringAsFixed(0) : "(${MathUtils.toFraction(slope)})"}x ${intercept >= 0 ? '+' : '-'} ${intercept.abs().toStringAsFixed(2)}',
    );
    _calculateIntersection();
  }

  void setSecondLineFromEquation(String raw) {
    if (!raw.contains('=')) return;

    try {
      final parts = raw.split('=');
      final lhs = parts[0].trim();
      final rhs = parts[1].trim();

      if (lhs == 'x') {
        final k = double.tryParse(rhs);
        if (k != null) {
          setSecondLine(double.infinity, k);
        }
        return;
      }

      final normRhs = _normalize(rhs);
      final parser = Parser();
      final exp = parser.parse(normRhs);

      final varRegex = RegExp(r'\b([a-zA-Z][a-zA-Z0-9]*)\b');
      final matches = varRegex.allMatches(normRhs).map((m) => m.group(0)!).toList();
      final functions = {
        'sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'ln', 'log', 'sqrt', 'abs', 'ceil', 'floor', 'round'
      };
      final xLabel = matches.firstWhere((m) => !functions.contains(m), orElse: () => 'x');

      final context = ContextModel();

      double eval(double val) {
        context.bindVariable(Variable(xLabel), Number(val));
        return exp.evaluate(EvaluationType.REAL, context) as double;
      }

      final b = eval(0);
      final m = eval(1) - b;

      setSecondLine(m, b);
    } catch (e, s) {
      developer.log('Failed to parse Line 2 equation', name: 'slope.ctrl', error: e, stackTrace: s);
    }
  }

  void clearSecondLine() {
    state = state.copyWith(
      secondSlope: null,
      secondYIntercept: null,
      secondEquation: null,
      intersectionPoint: null,
      intersectionStatus: null,
      segmentIntersections: const [],
    );
  }

  void _calculateIntersection() {
    final m1 = state.slope;
    final b1 = state.yIntercept;
    final m2 = state.secondSlope;
    final b2 = state.secondYIntercept;

    if (m1 == null || m2 == null) return;

    // 1. Calculate regression line intersection
    SlopePoint? regPt;
    String status = "INTERSECTING";

    if (m1 == double.infinity) {
      final x1 = state.points[0].x;
      if (m2 == double.infinity) {
        final x2 = b2!;
        if ((x1 - x2).abs() < 1e-10) {
          status = "IDENTICAL";
        } else {
          status = "PARALLEL";
        }
      } else {
        final y = m2 * x1 + b2!;
        regPt = SlopePoint(x: x1, y: y);
      }
    } else if (m2 == double.infinity) {
      final x2 = b2!;
      final y = m1 * x2 + b1!;
      regPt = SlopePoint(x: x2, y: y);
    } else {
      if ((m1 - m2).abs() < 1e-10) {
        if ((b1! - b2!).abs() < 1e-10) {
          status = "IDENTICAL";
        } else {
          status = "PARALLEL";
        }
      } else {
        final x = (b2! - b1!) / (m1 - m2);
        final y = m1 * x + b1;
        regPt = SlopePoint(x: x, y: y);
      }
    }

    // 2. Calculate segment intersections
    final segPts = <SlopePoint>[];
    final pts = state.points;
    if (pts.length > 1) {
      for (int i = 0; i < pts.length - 1; i++) {
        final pA = pts[i];
        final pB = pts[i + 1];

        final dx = pB.x - pA.x;
        final dy = pB.y - pA.y;

        SlopePoint? sect;
        if (dx.abs() < 1e-10) {
          // Vertical segment: x = pA.x
          final xSeg = pA.x;
          if (m2 == double.infinity) {
            // Both are vertical - no single intersection point
          } else {
            final ySect = m2 * xSeg + b2;
            sect = SlopePoint(x: xSeg, y: ySect);
          }
        } else {
          final mSeg = dy / dx;
          final bSeg = pA.y - mSeg * pA.x;

          if (m2 == double.infinity) {
            final xSeg = b2;
            final ySect = mSeg * xSeg + bSeg;
            sect = SlopePoint(x: xSeg, y: ySect);
          } else {
            if ((mSeg - m2).abs() > 1e-10) {
              final xSect = (b2 - bSeg) / (mSeg - m2);
              final ySect = mSeg * xSect + bSeg;
              sect = SlopePoint(x: xSect, y: ySect);
            }
          }
        }

        if (sect != null) {
          final minX = math.min(pA.x, pB.x) - 1e-9;
          final maxX = math.max(pA.x, pB.x) + 1e-9;
          final minY = math.min(pA.y, pB.y) - 1e-9;
          final maxY = math.max(pA.y, pB.y) + 1e-9;

          if (sect.x >= minX && sect.x <= maxX && sect.y >= minY && sect.y <= maxY) {
            final isDuplicate = segPts.any((p) => (p.x - sect!.x).abs() < 1e-9 && (p.y - sect.y).abs() < 1e-9);
            if (!isDuplicate) {
              segPts.add(sect);
            }
          }
        }
      }
    }

    state = state.copyWith(
      intersectionStatus: status,
      intersectionPoint: regPt,
      segmentIntersections: segPts,
    );
  }

  void setCheckPoint(double x, double y) {
    state = state.copyWith(checkPoint: SlopePoint(x: x, y: y));
  }

  void clearCheckPoint() {
    state = state.copyWith(checkPoint: null);
  }

  String _normalize(String input) {
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
}
