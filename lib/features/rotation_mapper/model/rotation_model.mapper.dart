// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'rotation_model.dart';

class RotationStateMapper extends ClassMapperBase<RotationState> {
  RotationStateMapper._();

  static RotationStateMapper? _instance;
  static RotationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RotationStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RotationState';

  static double? _$x(RotationState v) => v.x;
  static const Field<RotationState, double> _f$x = Field('x', _$x, opt: true);
  static double? _$y(RotationState v) => v.y;
  static const Field<RotationState, double> _f$y = Field('y', _$y, opt: true);

  @override
  final MappableFields<RotationState> fields = const {#x: _f$x, #y: _f$y};

  static RotationState _instantiate(DecodingData data) {
    return RotationState(x: data.dec(_f$x), y: data.dec(_f$y));
  }

  @override
  final Function instantiate = _instantiate;

  static RotationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RotationState>(map);
  }

  static RotationState fromJson(String json) {
    return ensureInitialized().decodeJson<RotationState>(json);
  }
}

mixin RotationStateMappable {
  String toJson() {
    return RotationStateMapper.ensureInitialized().encodeJson<RotationState>(
      this as RotationState,
    );
  }

  Map<String, dynamic> toMap() {
    return RotationStateMapper.ensureInitialized().encodeMap<RotationState>(
      this as RotationState,
    );
  }

  RotationStateCopyWith<RotationState, RotationState, RotationState>
  get copyWith => _RotationStateCopyWithImpl<RotationState, RotationState>(
    this as RotationState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return RotationStateMapper.ensureInitialized().stringifyValue(
      this as RotationState,
    );
  }

  @override
  bool operator ==(Object other) {
    return RotationStateMapper.ensureInitialized().equalsValue(
      this as RotationState,
      other,
    );
  }

  @override
  int get hashCode {
    return RotationStateMapper.ensureInitialized().hashValue(
      this as RotationState,
    );
  }
}

extension RotationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RotationState, $Out> {
  RotationStateCopyWith<$R, RotationState, $Out> get $asRotationState =>
      $base.as((v, t, t2) => _RotationStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RotationStateCopyWith<$R, $In extends RotationState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? x, double? y});
  RotationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RotationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RotationState, $Out>
    implements RotationStateCopyWith<$R, RotationState, $Out> {
  _RotationStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RotationState> $mapper =
      RotationStateMapper.ensureInitialized();
  @override
  $R call({Object? x = $none, Object? y = $none}) =>
      $apply(FieldCopyWithData({if (x != $none) #x: x, if (y != $none) #y: y}));
  @override
  RotationState $make(CopyWithData data) => RotationState(
    x: data.get(#x, or: $value.x),
    y: data.get(#y, or: $value.y),
  );

  @override
  RotationStateCopyWith<$R2, RotationState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RotationStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

