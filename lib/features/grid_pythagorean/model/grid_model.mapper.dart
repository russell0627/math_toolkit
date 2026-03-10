// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'grid_model.dart';

class GridPythagoreanStateMapper extends ClassMapperBase<GridPythagoreanState> {
  GridPythagoreanStateMapper._();

  static GridPythagoreanStateMapper? _instance;
  static GridPythagoreanStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GridPythagoreanStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'GridPythagoreanState';

  static double? _$x1(GridPythagoreanState v) => v.x1;
  static const Field<GridPythagoreanState, double> _f$x1 = Field(
    'x1',
    _$x1,
    opt: true,
  );
  static double? _$y1(GridPythagoreanState v) => v.y1;
  static const Field<GridPythagoreanState, double> _f$y1 = Field(
    'y1',
    _$y1,
    opt: true,
  );
  static double? _$x2(GridPythagoreanState v) => v.x2;
  static const Field<GridPythagoreanState, double> _f$x2 = Field(
    'x2',
    _$x2,
    opt: true,
  );
  static double? _$y2(GridPythagoreanState v) => v.y2;
  static const Field<GridPythagoreanState, double> _f$y2 = Field(
    'y2',
    _$y2,
    opt: true,
  );

  @override
  final MappableFields<GridPythagoreanState> fields = const {
    #x1: _f$x1,
    #y1: _f$y1,
    #x2: _f$x2,
    #y2: _f$y2,
  };

  static GridPythagoreanState _instantiate(DecodingData data) {
    return GridPythagoreanState(
      x1: data.dec(_f$x1),
      y1: data.dec(_f$y1),
      x2: data.dec(_f$x2),
      y2: data.dec(_f$y2),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static GridPythagoreanState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<GridPythagoreanState>(map);
  }

  static GridPythagoreanState fromJson(String json) {
    return ensureInitialized().decodeJson<GridPythagoreanState>(json);
  }
}

mixin GridPythagoreanStateMappable {
  String toJson() {
    return GridPythagoreanStateMapper.ensureInitialized()
        .encodeJson<GridPythagoreanState>(this as GridPythagoreanState);
  }

  Map<String, dynamic> toMap() {
    return GridPythagoreanStateMapper.ensureInitialized()
        .encodeMap<GridPythagoreanState>(this as GridPythagoreanState);
  }

  GridPythagoreanStateCopyWith<
    GridPythagoreanState,
    GridPythagoreanState,
    GridPythagoreanState
  >
  get copyWith =>
      _GridPythagoreanStateCopyWithImpl<
        GridPythagoreanState,
        GridPythagoreanState
      >(this as GridPythagoreanState, $identity, $identity);
  @override
  String toString() {
    return GridPythagoreanStateMapper.ensureInitialized().stringifyValue(
      this as GridPythagoreanState,
    );
  }

  @override
  bool operator ==(Object other) {
    return GridPythagoreanStateMapper.ensureInitialized().equalsValue(
      this as GridPythagoreanState,
      other,
    );
  }

  @override
  int get hashCode {
    return GridPythagoreanStateMapper.ensureInitialized().hashValue(
      this as GridPythagoreanState,
    );
  }
}

extension GridPythagoreanStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, GridPythagoreanState, $Out> {
  GridPythagoreanStateCopyWith<$R, GridPythagoreanState, $Out>
  get $asGridPythagoreanState => $base.as(
    (v, t, t2) => _GridPythagoreanStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class GridPythagoreanStateCopyWith<
  $R,
  $In extends GridPythagoreanState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? x1, double? y1, double? x2, double? y2});
  GridPythagoreanStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _GridPythagoreanStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, GridPythagoreanState, $Out>
    implements GridPythagoreanStateCopyWith<$R, GridPythagoreanState, $Out> {
  _GridPythagoreanStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<GridPythagoreanState> $mapper =
      GridPythagoreanStateMapper.ensureInitialized();
  @override
  $R call({
    Object? x1 = $none,
    Object? y1 = $none,
    Object? x2 = $none,
    Object? y2 = $none,
  }) => $apply(
    FieldCopyWithData({
      if (x1 != $none) #x1: x1,
      if (y1 != $none) #y1: y1,
      if (x2 != $none) #x2: x2,
      if (y2 != $none) #y2: y2,
    }),
  );
  @override
  GridPythagoreanState $make(CopyWithData data) => GridPythagoreanState(
    x1: data.get(#x1, or: $value.x1),
    y1: data.get(#y1, or: $value.y1),
    x2: data.get(#x2, or: $value.x2),
    y2: data.get(#y2, or: $value.y2),
  );

  @override
  GridPythagoreanStateCopyWith<$R2, GridPythagoreanState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GridPythagoreanStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

