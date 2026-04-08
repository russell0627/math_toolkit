// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'slope_model.dart';

class SlopePointMapper extends ClassMapperBase<SlopePoint> {
  SlopePointMapper._();

  static SlopePointMapper? _instance;
  static SlopePointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SlopePointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SlopePoint';

  static double _$x(SlopePoint v) => v.x;
  static const Field<SlopePoint, double> _f$x = Field('x', _$x);
  static double _$y(SlopePoint v) => v.y;
  static const Field<SlopePoint, double> _f$y = Field('y', _$y);

  @override
  final MappableFields<SlopePoint> fields = const {#x: _f$x, #y: _f$y};

  static SlopePoint _instantiate(DecodingData data) {
    return SlopePoint(x: data.dec(_f$x), y: data.dec(_f$y));
  }

  @override
  final Function instantiate = _instantiate;

  static SlopePoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SlopePoint>(map);
  }

  static SlopePoint fromJson(String json) {
    return ensureInitialized().decodeJson<SlopePoint>(json);
  }
}

mixin SlopePointMappable {
  String toJson() {
    return SlopePointMapper.ensureInitialized().encodeJson<SlopePoint>(
      this as SlopePoint,
    );
  }

  Map<String, dynamic> toMap() {
    return SlopePointMapper.ensureInitialized().encodeMap<SlopePoint>(
      this as SlopePoint,
    );
  }

  SlopePointCopyWith<SlopePoint, SlopePoint, SlopePoint> get copyWith =>
      _SlopePointCopyWithImpl<SlopePoint, SlopePoint>(
        this as SlopePoint,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SlopePointMapper.ensureInitialized().stringifyValue(
      this as SlopePoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return SlopePointMapper.ensureInitialized().equalsValue(
      this as SlopePoint,
      other,
    );
  }

  @override
  int get hashCode {
    return SlopePointMapper.ensureInitialized().hashValue(this as SlopePoint);
  }
}

extension SlopePointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SlopePoint, $Out> {
  SlopePointCopyWith<$R, SlopePoint, $Out> get $asSlopePoint =>
      $base.as((v, t, t2) => _SlopePointCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SlopePointCopyWith<$R, $In extends SlopePoint, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? x, double? y});
  SlopePointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SlopePointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SlopePoint, $Out>
    implements SlopePointCopyWith<$R, SlopePoint, $Out> {
  _SlopePointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SlopePoint> $mapper =
      SlopePointMapper.ensureInitialized();
  @override
  $R call({double? x, double? y}) =>
      $apply(FieldCopyWithData({if (x != null) #x: x, if (y != null) #y: y}));
  @override
  SlopePoint $make(CopyWithData data) => SlopePoint(
    x: data.get(#x, or: $value.x),
    y: data.get(#y, or: $value.y),
  );

  @override
  SlopePointCopyWith<$R2, SlopePoint, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SlopePointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SlopeStateMapper extends ClassMapperBase<SlopeState> {
  SlopeStateMapper._();

  static SlopeStateMapper? _instance;
  static SlopeStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SlopeStateMapper._());
      SlopePointMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SlopeState';

  static List<SlopePoint> _$points(SlopeState v) => v.points;
  static const Field<SlopeState, List<SlopePoint>> _f$points = Field(
    'points',
    _$points,
    opt: true,
    def: const [],
  );
  static double? _$slope(SlopeState v) => v.slope;
  static const Field<SlopeState, double> _f$slope = Field(
    'slope',
    _$slope,
    opt: true,
  );
  static double? _$yIntercept(SlopeState v) => v.yIntercept;
  static const Field<SlopeState, double> _f$yIntercept = Field(
    'yIntercept',
    _$yIntercept,
    opt: true,
  );
  static String? _$equation(SlopeState v) => v.equation;
  static const Field<SlopeState, String> _f$equation = Field(
    'equation',
    _$equation,
    opt: true,
  );
  static double? _$rise(SlopeState v) => v.rise;
  static const Field<SlopeState, double> _f$rise = Field(
    'rise',
    _$rise,
    opt: true,
  );
  static double? _$run(SlopeState v) => v.run;
  static const Field<SlopeState, double> _f$run = Field(
    'run',
    _$run,
    opt: true,
  );
  static double? _$distance(SlopeState v) => v.distance;
  static const Field<SlopeState, double> _f$distance = Field(
    'distance',
    _$distance,
    opt: true,
  );
  static List<double> _$segmentDistances(SlopeState v) => v.segmentDistances;
  static const Field<SlopeState, List<double>> _f$segmentDistances = Field(
    'segmentDistances',
    _$segmentDistances,
    opt: true,
    def: const [],
  );
  static List<double> _$segmentRises(SlopeState v) => v.segmentRises;
  static const Field<SlopeState, List<double>> _f$segmentRises = Field(
    'segmentRises',
    _$segmentRises,
    opt: true,
    def: const [],
  );
  static List<double> _$segmentRuns(SlopeState v) => v.segmentRuns;
  static const Field<SlopeState, List<double>> _f$segmentRuns = Field(
    'segmentRuns',
    _$segmentRuns,
    opt: true,
    def: const [],
  );
  static List<double> _$segmentSlopes(SlopeState v) => v.segmentSlopes;
  static const Field<SlopeState, List<double>> _f$segmentSlopes = Field(
    'segmentSlopes',
    _$segmentSlopes,
    opt: true,
    def: const [],
  );
  static String? _$slopeFraction(SlopeState v) => v.slopeFraction;
  static const Field<SlopeState, String> _f$slopeFraction = Field(
    'slopeFraction',
    _$slopeFraction,
    opt: true,
  );
  static List<String> _$segmentSlopesFractions(SlopeState v) =>
      v.segmentSlopesFractions;
  static const Field<SlopeState, List<String>> _f$segmentSlopesFractions =
      Field(
        'segmentSlopesFractions',
        _$segmentSlopesFractions,
        opt: true,
        def: const [],
      );
  static bool _$isProportional(SlopeState v) => v.isProportional;
  static const Field<SlopeState, bool> _f$isProportional = Field(
    'isProportional',
    _$isProportional,
    opt: true,
    def: false,
  );
  static double? _$proportionalityConstant(SlopeState v) =>
      v.proportionalityConstant;
  static const Field<SlopeState, double> _f$proportionalityConstant = Field(
    'proportionalityConstant',
    _$proportionalityConstant,
    opt: true,
  );
  static String? _$proportionalityFraction(SlopeState v) =>
      v.proportionalityFraction;
  static const Field<SlopeState, String> _f$proportionalityFraction = Field(
    'proportionalityFraction',
    _$proportionalityFraction,
    opt: true,
  );
  static List<double?> _$pointRatios(SlopeState v) => v.pointRatios;
  static const Field<SlopeState, List<double?>> _f$pointRatios = Field(
    'pointRatios',
    _$pointRatios,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SlopeState> fields = const {
    #points: _f$points,
    #slope: _f$slope,
    #yIntercept: _f$yIntercept,
    #equation: _f$equation,
    #rise: _f$rise,
    #run: _f$run,
    #distance: _f$distance,
    #segmentDistances: _f$segmentDistances,
    #segmentRises: _f$segmentRises,
    #segmentRuns: _f$segmentRuns,
    #segmentSlopes: _f$segmentSlopes,
    #slopeFraction: _f$slopeFraction,
    #segmentSlopesFractions: _f$segmentSlopesFractions,
    #isProportional: _f$isProportional,
    #proportionalityConstant: _f$proportionalityConstant,
    #proportionalityFraction: _f$proportionalityFraction,
    #pointRatios: _f$pointRatios,
  };

  static SlopeState _instantiate(DecodingData data) {
    return SlopeState(
      points: data.dec(_f$points),
      slope: data.dec(_f$slope),
      yIntercept: data.dec(_f$yIntercept),
      equation: data.dec(_f$equation),
      rise: data.dec(_f$rise),
      run: data.dec(_f$run),
      distance: data.dec(_f$distance),
      segmentDistances: data.dec(_f$segmentDistances),
      segmentRises: data.dec(_f$segmentRises),
      segmentRuns: data.dec(_f$segmentRuns),
      segmentSlopes: data.dec(_f$segmentSlopes),
      slopeFraction: data.dec(_f$slopeFraction),
      segmentSlopesFractions: data.dec(_f$segmentSlopesFractions),
      isProportional: data.dec(_f$isProportional),
      proportionalityConstant: data.dec(_f$proportionalityConstant),
      proportionalityFraction: data.dec(_f$proportionalityFraction),
      pointRatios: data.dec(_f$pointRatios),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SlopeState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SlopeState>(map);
  }

  static SlopeState fromJson(String json) {
    return ensureInitialized().decodeJson<SlopeState>(json);
  }
}

mixin SlopeStateMappable {
  String toJson() {
    return SlopeStateMapper.ensureInitialized().encodeJson<SlopeState>(
      this as SlopeState,
    );
  }

  Map<String, dynamic> toMap() {
    return SlopeStateMapper.ensureInitialized().encodeMap<SlopeState>(
      this as SlopeState,
    );
  }

  SlopeStateCopyWith<SlopeState, SlopeState, SlopeState> get copyWith =>
      _SlopeStateCopyWithImpl<SlopeState, SlopeState>(
        this as SlopeState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SlopeStateMapper.ensureInitialized().stringifyValue(
      this as SlopeState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SlopeStateMapper.ensureInitialized().equalsValue(
      this as SlopeState,
      other,
    );
  }

  @override
  int get hashCode {
    return SlopeStateMapper.ensureInitialized().hashValue(this as SlopeState);
  }
}

extension SlopeStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SlopeState, $Out> {
  SlopeStateCopyWith<$R, SlopeState, $Out> get $asSlopeState =>
      $base.as((v, t, t2) => _SlopeStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SlopeStateCopyWith<$R, $In extends SlopeState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, SlopePoint, SlopePointCopyWith<$R, SlopePoint, SlopePoint>>
  get points;
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentDistances;
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get segmentRises;
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>> get segmentRuns;
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentSlopes;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get segmentSlopesFractions;
  ListCopyWith<$R, double?, ObjectCopyWith<$R, double?, double?>?>
  get pointRatios;
  $R call({
    List<SlopePoint>? points,
    double? slope,
    double? yIntercept,
    String? equation,
    double? rise,
    double? run,
    double? distance,
    List<double>? segmentDistances,
    List<double>? segmentRises,
    List<double>? segmentRuns,
    List<double>? segmentSlopes,
    String? slopeFraction,
    List<String>? segmentSlopesFractions,
    bool? isProportional,
    double? proportionalityConstant,
    String? proportionalityFraction,
    List<double?>? pointRatios,
  });
  SlopeStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SlopeStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SlopeState, $Out>
    implements SlopeStateCopyWith<$R, SlopeState, $Out> {
  _SlopeStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SlopeState> $mapper =
      SlopeStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, SlopePoint, SlopePointCopyWith<$R, SlopePoint, SlopePoint>>
  get points => ListCopyWith(
    $value.points,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(points: v),
  );
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentDistances => ListCopyWith(
    $value.segmentDistances,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(segmentDistances: v),
  );
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentRises => ListCopyWith(
    $value.segmentRises,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(segmentRises: v),
  );
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentRuns => ListCopyWith(
    $value.segmentRuns,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(segmentRuns: v),
  );
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>
  get segmentSlopes => ListCopyWith(
    $value.segmentSlopes,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(segmentSlopes: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get segmentSlopesFractions => ListCopyWith(
    $value.segmentSlopesFractions,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(segmentSlopesFractions: v),
  );
  @override
  ListCopyWith<$R, double?, ObjectCopyWith<$R, double?, double?>?>
  get pointRatios => ListCopyWith(
    $value.pointRatios,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(pointRatios: v),
  );
  @override
  $R call({
    List<SlopePoint>? points,
    Object? slope = $none,
    Object? yIntercept = $none,
    Object? equation = $none,
    Object? rise = $none,
    Object? run = $none,
    Object? distance = $none,
    List<double>? segmentDistances,
    List<double>? segmentRises,
    List<double>? segmentRuns,
    List<double>? segmentSlopes,
    Object? slopeFraction = $none,
    List<String>? segmentSlopesFractions,
    bool? isProportional,
    Object? proportionalityConstant = $none,
    Object? proportionalityFraction = $none,
    List<double?>? pointRatios,
  }) => $apply(
    FieldCopyWithData({
      if (points != null) #points: points,
      if (slope != $none) #slope: slope,
      if (yIntercept != $none) #yIntercept: yIntercept,
      if (equation != $none) #equation: equation,
      if (rise != $none) #rise: rise,
      if (run != $none) #run: run,
      if (distance != $none) #distance: distance,
      if (segmentDistances != null) #segmentDistances: segmentDistances,
      if (segmentRises != null) #segmentRises: segmentRises,
      if (segmentRuns != null) #segmentRuns: segmentRuns,
      if (segmentSlopes != null) #segmentSlopes: segmentSlopes,
      if (slopeFraction != $none) #slopeFraction: slopeFraction,
      if (segmentSlopesFractions != null)
        #segmentSlopesFractions: segmentSlopesFractions,
      if (isProportional != null) #isProportional: isProportional,
      if (proportionalityConstant != $none)
        #proportionalityConstant: proportionalityConstant,
      if (proportionalityFraction != $none)
        #proportionalityFraction: proportionalityFraction,
      if (pointRatios != null) #pointRatios: pointRatios,
    }),
  );
  @override
  SlopeState $make(CopyWithData data) => SlopeState(
    points: data.get(#points, or: $value.points),
    slope: data.get(#slope, or: $value.slope),
    yIntercept: data.get(#yIntercept, or: $value.yIntercept),
    equation: data.get(#equation, or: $value.equation),
    rise: data.get(#rise, or: $value.rise),
    run: data.get(#run, or: $value.run),
    distance: data.get(#distance, or: $value.distance),
    segmentDistances: data.get(#segmentDistances, or: $value.segmentDistances),
    segmentRises: data.get(#segmentRises, or: $value.segmentRises),
    segmentRuns: data.get(#segmentRuns, or: $value.segmentRuns),
    segmentSlopes: data.get(#segmentSlopes, or: $value.segmentSlopes),
    slopeFraction: data.get(#slopeFraction, or: $value.slopeFraction),
    segmentSlopesFractions: data.get(
      #segmentSlopesFractions,
      or: $value.segmentSlopesFractions,
    ),
    isProportional: data.get(#isProportional, or: $value.isProportional),
    proportionalityConstant: data.get(
      #proportionalityConstant,
      or: $value.proportionalityConstant,
    ),
    proportionalityFraction: data.get(
      #proportionalityFraction,
      or: $value.proportionalityFraction,
    ),
    pointRatios: data.get(#pointRatios, or: $value.pointRatios),
  );

  @override
  SlopeStateCopyWith<$R2, SlopeState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SlopeStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

