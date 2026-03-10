// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'reflection_model.dart';

class ReflectionStateMapper extends ClassMapperBase<ReflectionState> {
  ReflectionStateMapper._();

  static ReflectionStateMapper? _instance;
  static ReflectionStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReflectionStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReflectionState';

  static double? _$x(ReflectionState v) => v.x;
  static const Field<ReflectionState, double> _f$x = Field('x', _$x, opt: true);
  static double? _$y(ReflectionState v) => v.y;
  static const Field<ReflectionState, double> _f$y = Field('y', _$y, opt: true);

  @override
  final MappableFields<ReflectionState> fields = const {#x: _f$x, #y: _f$y};

  static ReflectionState _instantiate(DecodingData data) {
    return ReflectionState(x: data.dec(_f$x), y: data.dec(_f$y));
  }

  @override
  final Function instantiate = _instantiate;

  static ReflectionState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReflectionState>(map);
  }

  static ReflectionState fromJson(String json) {
    return ensureInitialized().decodeJson<ReflectionState>(json);
  }
}

mixin ReflectionStateMappable {
  String toJson() {
    return ReflectionStateMapper.ensureInitialized()
        .encodeJson<ReflectionState>(this as ReflectionState);
  }

  Map<String, dynamic> toMap() {
    return ReflectionStateMapper.ensureInitialized().encodeMap<ReflectionState>(
      this as ReflectionState,
    );
  }

  ReflectionStateCopyWith<ReflectionState, ReflectionState, ReflectionState>
  get copyWith =>
      _ReflectionStateCopyWithImpl<ReflectionState, ReflectionState>(
        this as ReflectionState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReflectionStateMapper.ensureInitialized().stringifyValue(
      this as ReflectionState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReflectionStateMapper.ensureInitialized().equalsValue(
      this as ReflectionState,
      other,
    );
  }

  @override
  int get hashCode {
    return ReflectionStateMapper.ensureInitialized().hashValue(
      this as ReflectionState,
    );
  }
}

extension ReflectionStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReflectionState, $Out> {
  ReflectionStateCopyWith<$R, ReflectionState, $Out> get $asReflectionState =>
      $base.as((v, t, t2) => _ReflectionStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReflectionStateCopyWith<$R, $In extends ReflectionState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? x, double? y});
  ReflectionStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ReflectionStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReflectionState, $Out>
    implements ReflectionStateCopyWith<$R, ReflectionState, $Out> {
  _ReflectionStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReflectionState> $mapper =
      ReflectionStateMapper.ensureInitialized();
  @override
  $R call({Object? x = $none, Object? y = $none}) =>
      $apply(FieldCopyWithData({if (x != $none) #x: x, if (y != $none) #y: y}));
  @override
  ReflectionState $make(CopyWithData data) => ReflectionState(
    x: data.get(#x, or: $value.x),
    y: data.get(#y, or: $value.y),
  );

  @override
  ReflectionStateCopyWith<$R2, ReflectionState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReflectionStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

