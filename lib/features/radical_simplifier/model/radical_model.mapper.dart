// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'radical_model.dart';

class RadicalStateMapper extends ClassMapperBase<RadicalState> {
  RadicalStateMapper._();

  static RadicalStateMapper? _instance;
  static RadicalStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RadicalStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RadicalState';

  static int? _$inputRadicand(RadicalState v) => v.inputRadicand;
  static const Field<RadicalState, int> _f$inputRadicand = Field(
    'inputRadicand',
    _$inputRadicand,
    opt: true,
  );
  static int _$coefficient(RadicalState v) => v.coefficient;
  static const Field<RadicalState, int> _f$coefficient = Field(
    'coefficient',
    _$coefficient,
    opt: true,
    def: 1,
  );
  static int _$radicand(RadicalState v) => v.radicand;
  static const Field<RadicalState, int> _f$radicand = Field(
    'radicand',
    _$radicand,
    opt: true,
    def: 1,
  );
  static double? _$decimalValue(RadicalState v) => v.decimalValue;
  static const Field<RadicalState, double> _f$decimalValue = Field(
    'decimalValue',
    _$decimalValue,
    opt: true,
  );
  static int? _$lowerBound(RadicalState v) => v.lowerBound;
  static const Field<RadicalState, int> _f$lowerBound = Field(
    'lowerBound',
    _$lowerBound,
    opt: true,
  );
  static int? _$upperBound(RadicalState v) => v.upperBound;
  static const Field<RadicalState, int> _f$upperBound = Field(
    'upperBound',
    _$upperBound,
    opt: true,
  );

  @override
  final MappableFields<RadicalState> fields = const {
    #inputRadicand: _f$inputRadicand,
    #coefficient: _f$coefficient,
    #radicand: _f$radicand,
    #decimalValue: _f$decimalValue,
    #lowerBound: _f$lowerBound,
    #upperBound: _f$upperBound,
  };

  static RadicalState _instantiate(DecodingData data) {
    return RadicalState(
      inputRadicand: data.dec(_f$inputRadicand),
      coefficient: data.dec(_f$coefficient),
      radicand: data.dec(_f$radicand),
      decimalValue: data.dec(_f$decimalValue),
      lowerBound: data.dec(_f$lowerBound),
      upperBound: data.dec(_f$upperBound),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RadicalState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RadicalState>(map);
  }

  static RadicalState fromJson(String json) {
    return ensureInitialized().decodeJson<RadicalState>(json);
  }
}

mixin RadicalStateMappable {
  String toJson() {
    return RadicalStateMapper.ensureInitialized().encodeJson<RadicalState>(
      this as RadicalState,
    );
  }

  Map<String, dynamic> toMap() {
    return RadicalStateMapper.ensureInitialized().encodeMap<RadicalState>(
      this as RadicalState,
    );
  }

  RadicalStateCopyWith<RadicalState, RadicalState, RadicalState> get copyWith =>
      _RadicalStateCopyWithImpl<RadicalState, RadicalState>(
        this as RadicalState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RadicalStateMapper.ensureInitialized().stringifyValue(
      this as RadicalState,
    );
  }

  @override
  bool operator ==(Object other) {
    return RadicalStateMapper.ensureInitialized().equalsValue(
      this as RadicalState,
      other,
    );
  }

  @override
  int get hashCode {
    return RadicalStateMapper.ensureInitialized().hashValue(
      this as RadicalState,
    );
  }
}

extension RadicalStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RadicalState, $Out> {
  RadicalStateCopyWith<$R, RadicalState, $Out> get $asRadicalState =>
      $base.as((v, t, t2) => _RadicalStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RadicalStateCopyWith<$R, $In extends RadicalState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? inputRadicand,
    int? coefficient,
    int? radicand,
    double? decimalValue,
    int? lowerBound,
    int? upperBound,
  });
  RadicalStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RadicalStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RadicalState, $Out>
    implements RadicalStateCopyWith<$R, RadicalState, $Out> {
  _RadicalStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RadicalState> $mapper =
      RadicalStateMapper.ensureInitialized();
  @override
  $R call({
    Object? inputRadicand = $none,
    int? coefficient,
    int? radicand,
    Object? decimalValue = $none,
    Object? lowerBound = $none,
    Object? upperBound = $none,
  }) => $apply(
    FieldCopyWithData({
      if (inputRadicand != $none) #inputRadicand: inputRadicand,
      if (coefficient != null) #coefficient: coefficient,
      if (radicand != null) #radicand: radicand,
      if (decimalValue != $none) #decimalValue: decimalValue,
      if (lowerBound != $none) #lowerBound: lowerBound,
      if (upperBound != $none) #upperBound: upperBound,
    }),
  );
  @override
  RadicalState $make(CopyWithData data) => RadicalState(
    inputRadicand: data.get(#inputRadicand, or: $value.inputRadicand),
    coefficient: data.get(#coefficient, or: $value.coefficient),
    radicand: data.get(#radicand, or: $value.radicand),
    decimalValue: data.get(#decimalValue, or: $value.decimalValue),
    lowerBound: data.get(#lowerBound, or: $value.lowerBound),
    upperBound: data.get(#upperBound, or: $value.upperBound),
  );

  @override
  RadicalStateCopyWith<$R2, RadicalState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RadicalStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

