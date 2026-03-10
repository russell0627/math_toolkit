// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'triangle_model.dart';

class TriangleStateMapper extends ClassMapperBase<TriangleState> {
  TriangleStateMapper._();

  static TriangleStateMapper? _instance;
  static TriangleStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TriangleStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TriangleState';

  static double? _$angleA(TriangleState v) => v.angleA;
  static const Field<TriangleState, double> _f$angleA = Field(
    'angleA',
    _$angleA,
    opt: true,
  );
  static double? _$angleB(TriangleState v) => v.angleB;
  static const Field<TriangleState, double> _f$angleB = Field(
    'angleB',
    _$angleB,
    opt: true,
  );
  static double? _$angleC(TriangleState v) => v.angleC;
  static const Field<TriangleState, double> _f$angleC = Field(
    'angleC',
    _$angleC,
    opt: true,
  );
  static double? _$extA(TriangleState v) => v.extA;
  static const Field<TriangleState, double> _f$extA = Field(
    'extA',
    _$extA,
    opt: true,
  );
  static double? _$extB(TriangleState v) => v.extB;
  static const Field<TriangleState, double> _f$extB = Field(
    'extB',
    _$extB,
    opt: true,
  );
  static double? _$extC(TriangleState v) => v.extC;
  static const Field<TriangleState, double> _f$extC = Field(
    'extC',
    _$extC,
    opt: true,
  );
  static bool _$isUserA(TriangleState v) => v.isUserA;
  static const Field<TriangleState, bool> _f$isUserA = Field(
    'isUserA',
    _$isUserA,
    opt: true,
    def: false,
  );
  static bool _$isUserB(TriangleState v) => v.isUserB;
  static const Field<TriangleState, bool> _f$isUserB = Field(
    'isUserB',
    _$isUserB,
    opt: true,
    def: false,
  );
  static bool _$isUserC(TriangleState v) => v.isUserC;
  static const Field<TriangleState, bool> _f$isUserC = Field(
    'isUserC',
    _$isUserC,
    opt: true,
    def: false,
  );
  static bool _$isUserExtA(TriangleState v) => v.isUserExtA;
  static const Field<TriangleState, bool> _f$isUserExtA = Field(
    'isUserExtA',
    _$isUserExtA,
    opt: true,
    def: false,
  );
  static bool _$isUserExtB(TriangleState v) => v.isUserExtB;
  static const Field<TriangleState, bool> _f$isUserExtB = Field(
    'isUserExtB',
    _$isUserExtB,
    opt: true,
    def: false,
  );
  static bool _$isUserExtC(TriangleState v) => v.isUserExtC;
  static const Field<TriangleState, bool> _f$isUserExtC = Field(
    'isUserExtC',
    _$isUserExtC,
    opt: true,
    def: false,
  );
  static TriangleType _$type(TriangleState v) => v.type;
  static const Field<TriangleState, TriangleType> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: TriangleType.none,
  );

  @override
  final MappableFields<TriangleState> fields = const {
    #angleA: _f$angleA,
    #angleB: _f$angleB,
    #angleC: _f$angleC,
    #extA: _f$extA,
    #extB: _f$extB,
    #extC: _f$extC,
    #isUserA: _f$isUserA,
    #isUserB: _f$isUserB,
    #isUserC: _f$isUserC,
    #isUserExtA: _f$isUserExtA,
    #isUserExtB: _f$isUserExtB,
    #isUserExtC: _f$isUserExtC,
    #type: _f$type,
  };

  static TriangleState _instantiate(DecodingData data) {
    return TriangleState(
      angleA: data.dec(_f$angleA),
      angleB: data.dec(_f$angleB),
      angleC: data.dec(_f$angleC),
      extA: data.dec(_f$extA),
      extB: data.dec(_f$extB),
      extC: data.dec(_f$extC),
      isUserA: data.dec(_f$isUserA),
      isUserB: data.dec(_f$isUserB),
      isUserC: data.dec(_f$isUserC),
      isUserExtA: data.dec(_f$isUserExtA),
      isUserExtB: data.dec(_f$isUserExtB),
      isUserExtC: data.dec(_f$isUserExtC),
      type: data.dec(_f$type),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TriangleState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TriangleState>(map);
  }

  static TriangleState fromJson(String json) {
    return ensureInitialized().decodeJson<TriangleState>(json);
  }
}

mixin TriangleStateMappable {
  String toJson() {
    return TriangleStateMapper.ensureInitialized().encodeJson<TriangleState>(
      this as TriangleState,
    );
  }

  Map<String, dynamic> toMap() {
    return TriangleStateMapper.ensureInitialized().encodeMap<TriangleState>(
      this as TriangleState,
    );
  }

  TriangleStateCopyWith<TriangleState, TriangleState, TriangleState>
  get copyWith => _TriangleStateCopyWithImpl<TriangleState, TriangleState>(
    this as TriangleState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TriangleStateMapper.ensureInitialized().stringifyValue(
      this as TriangleState,
    );
  }

  @override
  bool operator ==(Object other) {
    return TriangleStateMapper.ensureInitialized().equalsValue(
      this as TriangleState,
      other,
    );
  }

  @override
  int get hashCode {
    return TriangleStateMapper.ensureInitialized().hashValue(
      this as TriangleState,
    );
  }
}

extension TriangleStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TriangleState, $Out> {
  TriangleStateCopyWith<$R, TriangleState, $Out> get $asTriangleState =>
      $base.as((v, t, t2) => _TriangleStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TriangleStateCopyWith<$R, $In extends TriangleState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
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
    TriangleType? type,
  });
  TriangleStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TriangleStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TriangleState, $Out>
    implements TriangleStateCopyWith<$R, TriangleState, $Out> {
  _TriangleStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TriangleState> $mapper =
      TriangleStateMapper.ensureInitialized();
  @override
  $R call({
    Object? angleA = $none,
    Object? angleB = $none,
    Object? angleC = $none,
    Object? extA = $none,
    Object? extB = $none,
    Object? extC = $none,
    bool? isUserA,
    bool? isUserB,
    bool? isUserC,
    bool? isUserExtA,
    bool? isUserExtB,
    bool? isUserExtC,
    TriangleType? type,
  }) => $apply(
    FieldCopyWithData({
      if (angleA != $none) #angleA: angleA,
      if (angleB != $none) #angleB: angleB,
      if (angleC != $none) #angleC: angleC,
      if (extA != $none) #extA: extA,
      if (extB != $none) #extB: extB,
      if (extC != $none) #extC: extC,
      if (isUserA != null) #isUserA: isUserA,
      if (isUserB != null) #isUserB: isUserB,
      if (isUserC != null) #isUserC: isUserC,
      if (isUserExtA != null) #isUserExtA: isUserExtA,
      if (isUserExtB != null) #isUserExtB: isUserExtB,
      if (isUserExtC != null) #isUserExtC: isUserExtC,
      if (type != null) #type: type,
    }),
  );
  @override
  TriangleState $make(CopyWithData data) => TriangleState(
    angleA: data.get(#angleA, or: $value.angleA),
    angleB: data.get(#angleB, or: $value.angleB),
    angleC: data.get(#angleC, or: $value.angleC),
    extA: data.get(#extA, or: $value.extA),
    extB: data.get(#extB, or: $value.extB),
    extC: data.get(#extC, or: $value.extC),
    isUserA: data.get(#isUserA, or: $value.isUserA),
    isUserB: data.get(#isUserB, or: $value.isUserB),
    isUserC: data.get(#isUserC, or: $value.isUserC),
    isUserExtA: data.get(#isUserExtA, or: $value.isUserExtA),
    isUserExtB: data.get(#isUserExtB, or: $value.isUserExtB),
    isUserExtC: data.get(#isUserExtC, or: $value.isUserExtC),
    type: data.get(#type, or: $value.type),
  );

  @override
  TriangleStateCopyWith<$R2, TriangleState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TriangleStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

