import 'package:dart_mappable/dart_mappable.dart';

part 'slope_model.mapper.dart';

@MappableClass()
class SlopePoint with SlopePointMappable {
  final double x;
  final double y;

  const SlopePoint({required this.x, required this.y});
}

@MappableClass()
class SlopeState with SlopeStateMappable {
  final List<SlopePoint> points;
  final double? slope;
  final double? yIntercept;
  final String? equation;
  final double? rise;
  final double? run;
  final double? distance;
  final List<double> segmentDistances;
  final List<double> segmentRises;
  final List<double> segmentRuns;
  final List<double> segmentSlopes;
  final String? slopeFraction;
  final List<String> segmentSlopesFractions;
  final bool isProportional;
  final double? proportionalityConstant;
  final String? proportionalityFraction;
  final List<double?> pointRatios;
  final String xLabel;
  final String yLabel;
  final String? inputEquation;
  final bool isMinimalMode;
  final bool isPerfectlyLinear;

  // Line 2 Intersection fields
  final double? secondSlope;
  final double? secondYIntercept;
  final String? secondEquation;
  final SlopePoint? intersectionPoint;
  final String? intersectionStatus;
  final List<SlopePoint> segmentIntersections;
  final SlopePoint? checkPoint;

  const SlopeState({
    this.points = const [],
    this.slope,
    this.yIntercept,
    this.equation,
    this.rise,
    this.run,
    this.distance,
    this.segmentDistances = const [],
    this.segmentRises = const [],
    this.segmentRuns = const [],
    this.segmentSlopes = const [],
    this.slopeFraction,
    this.segmentSlopesFractions = const [],
    this.isProportional = false,
    this.proportionalityConstant,
    this.proportionalityFraction,
    this.pointRatios = const [],
    this.xLabel = "X",
    this.yLabel = "Y",
    this.inputEquation,
    this.isMinimalMode = false,
    this.isPerfectlyLinear = true,
    this.secondSlope,
    this.secondYIntercept,
    this.secondEquation,
    this.intersectionPoint,
    this.intersectionStatus,
    this.segmentIntersections = const [],
    this.checkPoint,
  });
}
