// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transformation_sequence_model.dart';

class TransformationTypeMapper extends EnumMapper<TransformationType> {
  TransformationTypeMapper._();

  static TransformationTypeMapper? _instance;
  static TransformationTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransformationTypeMapper._());
    }
    return _instance!;
  }

  static TransformationType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TransformationType decode(dynamic value) {
    switch (value) {
      case r'reflectX':
        return TransformationType.reflectX;
      case r'reflectY':
        return TransformationType.reflectY;
      case r'reflectOrigin':
        return TransformationType.reflectOrigin;
      case r'rotate90CCW':
        return TransformationType.rotate90CCW;
      case r'rotate90CW':
        return TransformationType.rotate90CW;
      case r'rotate180':
        return TransformationType.rotate180;
      case r'rotate270CCW':
        return TransformationType.rotate270CCW;
      case r'rotate270CW':
        return TransformationType.rotate270CW;
      case r'translate':
        return TransformationType.translate;
      case r'dilate':
        return TransformationType.dilate;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TransformationType self) {
    switch (self) {
      case TransformationType.reflectX:
        return r'reflectX';
      case TransformationType.reflectY:
        return r'reflectY';
      case TransformationType.reflectOrigin:
        return r'reflectOrigin';
      case TransformationType.rotate90CCW:
        return r'rotate90CCW';
      case TransformationType.rotate90CW:
        return r'rotate90CW';
      case TransformationType.rotate180:
        return r'rotate180';
      case TransformationType.rotate270CCW:
        return r'rotate270CCW';
      case TransformationType.rotate270CW:
        return r'rotate270CW';
      case TransformationType.translate:
        return r'translate';
      case TransformationType.dilate:
        return r'dilate';
    }
  }
}

extension TransformationTypeMapperExtension on TransformationType {
  String toValue() {
    TransformationTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TransformationType>(this) as String;
  }
}

class TransformationStepMapper extends ClassMapperBase<TransformationStep> {
  TransformationStepMapper._();

  static TransformationStepMapper? _instance;
  static TransformationStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransformationStepMapper._());
      TransformationTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransformationStep';

  static TransformationType _$type(TransformationStep v) => v.type;
  static const Field<TransformationStep, TransformationType> _f$type = Field(
    'type',
    _$type,
  );
  static String _$expressionX(TransformationStep v) => v.expressionX;
  static const Field<TransformationStep, String> _f$expressionX = Field(
    'expressionX',
    _$expressionX,
  );
  static String _$expressionY(TransformationStep v) => v.expressionY;
  static const Field<TransformationStep, String> _f$expressionY = Field(
    'expressionY',
    _$expressionY,
  );
  static List<Offset> _$pointResults(TransformationStep v) => v.pointResults;
  static const Field<TransformationStep, List<Offset>> _f$pointResults = Field(
    'pointResults',
    _$pointResults,
    opt: true,
    def: const [],
  );
  static int? _$h(TransformationStep v) => v.h;
  static const Field<TransformationStep, int> _f$h = Field('h', _$h, opt: true);
  static int? _$k(TransformationStep v) => v.k;
  static const Field<TransformationStep, int> _f$k = Field('k', _$k, opt: true);
  static double? _$scale(TransformationStep v) => v.scale;
  static const Field<TransformationStep, double> _f$scale = Field(
    'scale',
    _$scale,
    opt: true,
  );
  static double? _$centerX(TransformationStep v) => v.centerX;
  static const Field<TransformationStep, double> _f$centerX = Field(
    'centerX',
    _$centerX,
    opt: true,
  );
  static double? _$centerY(TransformationStep v) => v.centerY;
  static const Field<TransformationStep, double> _f$centerY = Field(
    'centerY',
    _$centerY,
    opt: true,
  );

  @override
  final MappableFields<TransformationStep> fields = const {
    #type: _f$type,
    #expressionX: _f$expressionX,
    #expressionY: _f$expressionY,
    #pointResults: _f$pointResults,
    #h: _f$h,
    #k: _f$k,
    #scale: _f$scale,
    #centerX: _f$centerX,
    #centerY: _f$centerY,
  };

  static TransformationStep _instantiate(DecodingData data) {
    return TransformationStep(
      type: data.dec(_f$type),
      expressionX: data.dec(_f$expressionX),
      expressionY: data.dec(_f$expressionY),
      pointResults: data.dec(_f$pointResults),
      h: data.dec(_f$h),
      k: data.dec(_f$k),
      scale: data.dec(_f$scale),
      centerX: data.dec(_f$centerX),
      centerY: data.dec(_f$centerY),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransformationStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransformationStep>(map);
  }

  static TransformationStep fromJson(String json) {
    return ensureInitialized().decodeJson<TransformationStep>(json);
  }
}

mixin TransformationStepMappable {
  String toJson() {
    return TransformationStepMapper.ensureInitialized()
        .encodeJson<TransformationStep>(this as TransformationStep);
  }

  Map<String, dynamic> toMap() {
    return TransformationStepMapper.ensureInitialized()
        .encodeMap<TransformationStep>(this as TransformationStep);
  }

  TransformationStepCopyWith<
    TransformationStep,
    TransformationStep,
    TransformationStep
  >
  get copyWith =>
      _TransformationStepCopyWithImpl<TransformationStep, TransformationStep>(
        this as TransformationStep,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TransformationStepMapper.ensureInitialized().stringifyValue(
      this as TransformationStep,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransformationStepMapper.ensureInitialized().equalsValue(
      this as TransformationStep,
      other,
    );
  }

  @override
  int get hashCode {
    return TransformationStepMapper.ensureInitialized().hashValue(
      this as TransformationStep,
    );
  }
}

extension TransformationStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransformationStep, $Out> {
  TransformationStepCopyWith<$R, TransformationStep, $Out>
  get $asTransformationStep => $base.as(
    (v, t, t2) => _TransformationStepCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransformationStepCopyWith<
  $R,
  $In extends TransformationStep,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Offset, ObjectCopyWith<$R, Offset, Offset>> get pointResults;
  $R call({
    TransformationType? type,
    String? expressionX,
    String? expressionY,
    List<Offset>? pointResults,
    int? h,
    int? k,
    double? scale,
    double? centerX,
    double? centerY,
  });
  TransformationStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransformationStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransformationStep, $Out>
    implements TransformationStepCopyWith<$R, TransformationStep, $Out> {
  _TransformationStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TransformationStep> $mapper =
      TransformationStepMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Offset, ObjectCopyWith<$R, Offset, Offset>>
  get pointResults => ListCopyWith(
    $value.pointResults,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(pointResults: v),
  );
  @override
  $R call({
    TransformationType? type,
    String? expressionX,
    String? expressionY,
    List<Offset>? pointResults,
    Object? h = $none,
    Object? k = $none,
    Object? scale = $none,
    Object? centerX = $none,
    Object? centerY = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (expressionX != null) #expressionX: expressionX,
      if (expressionY != null) #expressionY: expressionY,
      if (pointResults != null) #pointResults: pointResults,
      if (h != $none) #h: h,
      if (k != $none) #k: k,
      if (scale != $none) #scale: scale,
      if (centerX != $none) #centerX: centerX,
      if (centerY != $none) #centerY: centerY,
    }),
  );
  @override
  TransformationStep $make(CopyWithData data) => TransformationStep(
    type: data.get(#type, or: $value.type),
    expressionX: data.get(#expressionX, or: $value.expressionX),
    expressionY: data.get(#expressionY, or: $value.expressionY),
    pointResults: data.get(#pointResults, or: $value.pointResults),
    h: data.get(#h, or: $value.h),
    k: data.get(#k, or: $value.k),
    scale: data.get(#scale, or: $value.scale),
    centerX: data.get(#centerX, or: $value.centerX),
    centerY: data.get(#centerY, or: $value.centerY),
  );

  @override
  TransformationStepCopyWith<$R2, TransformationStep, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TransformationStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TransformationSequenceStateMapper
    extends ClassMapperBase<TransformationSequenceState> {
  TransformationSequenceStateMapper._();

  static TransformationSequenceStateMapper? _instance;
  static TransformationSequenceStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TransformationSequenceStateMapper._(),
      );
      TransformationStepMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransformationSequenceState';

  static List<TransformationStep> _$steps(TransformationSequenceState v) =>
      v.steps;
  static const Field<TransformationSequenceState, List<TransformationStep>>
  _f$steps = Field('steps', _$steps, opt: true, def: const []);
  static List<Offset> _$points(TransformationSequenceState v) => v.points;
  static const Field<TransformationSequenceState, List<Offset>> _f$points =
      Field(
        'points',
        _$points,
        opt: true,
        def: const [Offset(2, 2), Offset(5, 2), Offset(2, 5)],
      );
  static int? _$selectedStepIndex(TransformationSequenceState v) =>
      v.selectedStepIndex;
  static const Field<TransformationSequenceState, int> _f$selectedStepIndex =
      Field('selectedStepIndex', _$selectedStepIndex, opt: true);
  static bool _$isQuickShape(TransformationSequenceState v) => v.isQuickShape;
  static const Field<TransformationSequenceState, bool> _f$isQuickShape = Field(
    'isQuickShape',
    _$isQuickShape,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<TransformationSequenceState> fields = const {
    #steps: _f$steps,
    #points: _f$points,
    #selectedStepIndex: _f$selectedStepIndex,
    #isQuickShape: _f$isQuickShape,
  };

  static TransformationSequenceState _instantiate(DecodingData data) {
    return TransformationSequenceState(
      steps: data.dec(_f$steps),
      points: data.dec(_f$points),
      selectedStepIndex: data.dec(_f$selectedStepIndex),
      isQuickShape: data.dec(_f$isQuickShape),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransformationSequenceState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransformationSequenceState>(map);
  }

  static TransformationSequenceState fromJson(String json) {
    return ensureInitialized().decodeJson<TransformationSequenceState>(json);
  }
}

mixin TransformationSequenceStateMappable {
  String toJson() {
    return TransformationSequenceStateMapper.ensureInitialized()
        .encodeJson<TransformationSequenceState>(
          this as TransformationSequenceState,
        );
  }

  Map<String, dynamic> toMap() {
    return TransformationSequenceStateMapper.ensureInitialized()
        .encodeMap<TransformationSequenceState>(
          this as TransformationSequenceState,
        );
  }

  TransformationSequenceStateCopyWith<
    TransformationSequenceState,
    TransformationSequenceState,
    TransformationSequenceState
  >
  get copyWith =>
      _TransformationSequenceStateCopyWithImpl<
        TransformationSequenceState,
        TransformationSequenceState
      >(this as TransformationSequenceState, $identity, $identity);
  @override
  String toString() {
    return TransformationSequenceStateMapper.ensureInitialized().stringifyValue(
      this as TransformationSequenceState,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransformationSequenceStateMapper.ensureInitialized().equalsValue(
      this as TransformationSequenceState,
      other,
    );
  }

  @override
  int get hashCode {
    return TransformationSequenceStateMapper.ensureInitialized().hashValue(
      this as TransformationSequenceState,
    );
  }
}

extension TransformationSequenceStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransformationSequenceState, $Out> {
  TransformationSequenceStateCopyWith<$R, TransformationSequenceState, $Out>
  get $asTransformationSequenceState => $base.as(
    (v, t, t2) => _TransformationSequenceStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransformationSequenceStateCopyWith<
  $R,
  $In extends TransformationSequenceState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    TransformationStep,
    TransformationStepCopyWith<$R, TransformationStep, TransformationStep>
  >
  get steps;
  ListCopyWith<$R, Offset, ObjectCopyWith<$R, Offset, Offset>> get points;
  $R call({
    List<TransformationStep>? steps,
    List<Offset>? points,
    int? selectedStepIndex,
    bool? isQuickShape,
  });
  TransformationSequenceStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransformationSequenceStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransformationSequenceState, $Out>
    implements
        TransformationSequenceStateCopyWith<
          $R,
          TransformationSequenceState,
          $Out
        > {
  _TransformationSequenceStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<TransformationSequenceState> $mapper =
      TransformationSequenceStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    TransformationStep,
    TransformationStepCopyWith<$R, TransformationStep, TransformationStep>
  >
  get steps => ListCopyWith(
    $value.steps,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(steps: v),
  );
  @override
  ListCopyWith<$R, Offset, ObjectCopyWith<$R, Offset, Offset>> get points =>
      ListCopyWith(
        $value.points,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(points: v),
      );
  @override
  $R call({
    List<TransformationStep>? steps,
    List<Offset>? points,
    Object? selectedStepIndex = $none,
    bool? isQuickShape,
  }) => $apply(
    FieldCopyWithData({
      if (steps != null) #steps: steps,
      if (points != null) #points: points,
      if (selectedStepIndex != $none) #selectedStepIndex: selectedStepIndex,
      if (isQuickShape != null) #isQuickShape: isQuickShape,
    }),
  );
  @override
  TransformationSequenceState $make(CopyWithData data) =>
      TransformationSequenceState(
        steps: data.get(#steps, or: $value.steps),
        points: data.get(#points, or: $value.points),
        selectedStepIndex: data.get(
          #selectedStepIndex,
          or: $value.selectedStepIndex,
        ),
        isQuickShape: data.get(#isQuickShape, or: $value.isQuickShape),
      );

  @override
  TransformationSequenceStateCopyWith<$R2, TransformationSequenceState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransformationSequenceStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

