// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pythagorean_model.dart';

class PythagoreanStateMapper extends ClassMapperBase<PythagoreanState> {
  PythagoreanStateMapper._();

  static PythagoreanStateMapper? _instance;
  static PythagoreanStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PythagoreanStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PythagoreanState';

  static double? _$sideA(PythagoreanState v) => v.sideA;
  static const Field<PythagoreanState, double> _f$sideA = Field(
    'sideA',
    _$sideA,
    opt: true,
  );
  static double? _$sideB(PythagoreanState v) => v.sideB;
  static const Field<PythagoreanState, double> _f$sideB = Field(
    'sideB',
    _$sideB,
    opt: true,
  );
  static double? _$sideC(PythagoreanState v) => v.sideC;
  static const Field<PythagoreanState, double> _f$sideC = Field(
    'sideC',
    _$sideC,
    opt: true,
  );
  static bool _$isUserA(PythagoreanState v) => v.isUserA;
  static const Field<PythagoreanState, bool> _f$isUserA = Field(
    'isUserA',
    _$isUserA,
    opt: true,
    def: false,
  );
  static bool _$isUserB(PythagoreanState v) => v.isUserB;
  static const Field<PythagoreanState, bool> _f$isUserB = Field(
    'isUserB',
    _$isUserB,
    opt: true,
    def: false,
  );
  static bool _$isUserC(PythagoreanState v) => v.isUserC;
  static const Field<PythagoreanState, bool> _f$isUserC = Field(
    'isUserC',
    _$isUserC,
    opt: true,
    def: false,
  );
  static int? _$lowerBound(PythagoreanState v) => v.lowerBound;
  static const Field<PythagoreanState, int> _f$lowerBound = Field(
    'lowerBound',
    _$lowerBound,
    opt: true,
  );
  static int? _$upperBound(PythagoreanState v) => v.upperBound;
  static const Field<PythagoreanState, int> _f$upperBound = Field(
    'upperBound',
    _$upperBound,
    opt: true,
  );

  @override
  final MappableFields<PythagoreanState> fields = const {
    #sideA: _f$sideA,
    #sideB: _f$sideB,
    #sideC: _f$sideC,
    #isUserA: _f$isUserA,
    #isUserB: _f$isUserB,
    #isUserC: _f$isUserC,
    #lowerBound: _f$lowerBound,
    #upperBound: _f$upperBound,
  };

  static PythagoreanState _instantiate(DecodingData data) {
    return PythagoreanState(
      sideA: data.dec(_f$sideA),
      sideB: data.dec(_f$sideB),
      sideC: data.dec(_f$sideC),
      isUserA: data.dec(_f$isUserA),
      isUserB: data.dec(_f$isUserB),
      isUserC: data.dec(_f$isUserC),
      lowerBound: data.dec(_f$lowerBound),
      upperBound: data.dec(_f$upperBound),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PythagoreanState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PythagoreanState>(map);
  }

  static PythagoreanState fromJson(String json) {
    return ensureInitialized().decodeJson<PythagoreanState>(json);
  }
}

mixin PythagoreanStateMappable {
  String toJson() {
    return PythagoreanStateMapper.ensureInitialized()
        .encodeJson<PythagoreanState>(this as PythagoreanState);
  }

  Map<String, dynamic> toMap() {
    return PythagoreanStateMapper.ensureInitialized()
        .encodeMap<PythagoreanState>(this as PythagoreanState);
  }

  PythagoreanStateCopyWith<PythagoreanState, PythagoreanState, PythagoreanState>
  get copyWith =>
      _PythagoreanStateCopyWithImpl<PythagoreanState, PythagoreanState>(
        this as PythagoreanState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PythagoreanStateMapper.ensureInitialized().stringifyValue(
      this as PythagoreanState,
    );
  }

  @override
  bool operator ==(Object other) {
    return PythagoreanStateMapper.ensureInitialized().equalsValue(
      this as PythagoreanState,
      other,
    );
  }

  @override
  int get hashCode {
    return PythagoreanStateMapper.ensureInitialized().hashValue(
      this as PythagoreanState,
    );
  }
}

extension PythagoreanStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PythagoreanState, $Out> {
  PythagoreanStateCopyWith<$R, PythagoreanState, $Out>
  get $asPythagoreanState =>
      $base.as((v, t, t2) => _PythagoreanStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PythagoreanStateCopyWith<$R, $In extends PythagoreanState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? sideA,
    double? sideB,
    double? sideC,
    bool? isUserA,
    bool? isUserB,
    bool? isUserC,
    int? lowerBound,
    int? upperBound,
  });
  PythagoreanStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PythagoreanStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PythagoreanState, $Out>
    implements PythagoreanStateCopyWith<$R, PythagoreanState, $Out> {
  _PythagoreanStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PythagoreanState> $mapper =
      PythagoreanStateMapper.ensureInitialized();
  @override
  $R call({
    Object? sideA = $none,
    Object? sideB = $none,
    Object? sideC = $none,
    bool? isUserA,
    bool? isUserB,
    bool? isUserC,
    Object? lowerBound = $none,
    Object? upperBound = $none,
  }) => $apply(
    FieldCopyWithData({
      if (sideA != $none) #sideA: sideA,
      if (sideB != $none) #sideB: sideB,
      if (sideC != $none) #sideC: sideC,
      if (isUserA != null) #isUserA: isUserA,
      if (isUserB != null) #isUserB: isUserB,
      if (isUserC != null) #isUserC: isUserC,
      if (lowerBound != $none) #lowerBound: lowerBound,
      if (upperBound != $none) #upperBound: upperBound,
    }),
  );
  @override
  PythagoreanState $make(CopyWithData data) => PythagoreanState(
    sideA: data.get(#sideA, or: $value.sideA),
    sideB: data.get(#sideB, or: $value.sideB),
    sideC: data.get(#sideC, or: $value.sideC),
    isUserA: data.get(#isUserA, or: $value.isUserA),
    isUserB: data.get(#isUserB, or: $value.isUserB),
    isUserC: data.get(#isUserC, or: $value.isUserC),
    lowerBound: data.get(#lowerBound, or: $value.lowerBound),
    upperBound: data.get(#upperBound, or: $value.upperBound),
  );

  @override
  PythagoreanStateCopyWith<$R2, PythagoreanState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PythagoreanStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

