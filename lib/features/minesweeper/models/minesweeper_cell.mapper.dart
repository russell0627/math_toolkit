// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'minesweeper_cell.dart';

class MinesweeperCellMapper extends ClassMapperBase<MinesweeperCell> {
  MinesweeperCellMapper._();

  static MinesweeperCellMapper? _instance;
  static MinesweeperCellMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MinesweeperCellMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MinesweeperCell';

  static bool _$isMine(MinesweeperCell v) => v.isMine;
  static const Field<MinesweeperCell, bool> _f$isMine = Field(
    'isMine',
    _$isMine,
    opt: true,
    def: false,
  );
  static bool _$isRevealed(MinesweeperCell v) => v.isRevealed;
  static const Field<MinesweeperCell, bool> _f$isRevealed = Field(
    'isRevealed',
    _$isRevealed,
    opt: true,
    def: false,
  );
  static bool _$isFlagged(MinesweeperCell v) => v.isFlagged;
  static const Field<MinesweeperCell, bool> _f$isFlagged = Field(
    'isFlagged',
    _$isFlagged,
    opt: true,
    def: false,
  );
  static int _$neighborCount(MinesweeperCell v) => v.neighborCount;
  static const Field<MinesweeperCell, int> _f$neighborCount = Field(
    'neighborCount',
    _$neighborCount,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<MinesweeperCell> fields = const {
    #isMine: _f$isMine,
    #isRevealed: _f$isRevealed,
    #isFlagged: _f$isFlagged,
    #neighborCount: _f$neighborCount,
  };

  static MinesweeperCell _instantiate(DecodingData data) {
    return MinesweeperCell(
      isMine: data.dec(_f$isMine),
      isRevealed: data.dec(_f$isRevealed),
      isFlagged: data.dec(_f$isFlagged),
      neighborCount: data.dec(_f$neighborCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MinesweeperCell fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MinesweeperCell>(map);
  }

  static MinesweeperCell fromJson(String json) {
    return ensureInitialized().decodeJson<MinesweeperCell>(json);
  }
}

mixin MinesweeperCellMappable {
  String toJson() {
    return MinesweeperCellMapper.ensureInitialized()
        .encodeJson<MinesweeperCell>(this as MinesweeperCell);
  }

  Map<String, dynamic> toMap() {
    return MinesweeperCellMapper.ensureInitialized().encodeMap<MinesweeperCell>(
      this as MinesweeperCell,
    );
  }

  MinesweeperCellCopyWith<MinesweeperCell, MinesweeperCell, MinesweeperCell>
  get copyWith =>
      _MinesweeperCellCopyWithImpl<MinesweeperCell, MinesweeperCell>(
        this as MinesweeperCell,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MinesweeperCellMapper.ensureInitialized().stringifyValue(
      this as MinesweeperCell,
    );
  }

  @override
  bool operator ==(Object other) {
    return MinesweeperCellMapper.ensureInitialized().equalsValue(
      this as MinesweeperCell,
      other,
    );
  }

  @override
  int get hashCode {
    return MinesweeperCellMapper.ensureInitialized().hashValue(
      this as MinesweeperCell,
    );
  }
}

extension MinesweeperCellValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MinesweeperCell, $Out> {
  MinesweeperCellCopyWith<$R, MinesweeperCell, $Out> get $asMinesweeperCell =>
      $base.as((v, t, t2) => _MinesweeperCellCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MinesweeperCellCopyWith<$R, $In extends MinesweeperCell, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    bool? isMine,
    bool? isRevealed,
    bool? isFlagged,
    int? neighborCount,
  });
  MinesweeperCellCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MinesweeperCellCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MinesweeperCell, $Out>
    implements MinesweeperCellCopyWith<$R, MinesweeperCell, $Out> {
  _MinesweeperCellCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MinesweeperCell> $mapper =
      MinesweeperCellMapper.ensureInitialized();
  @override
  $R call({
    bool? isMine,
    bool? isRevealed,
    bool? isFlagged,
    int? neighborCount,
  }) => $apply(
    FieldCopyWithData({
      if (isMine != null) #isMine: isMine,
      if (isRevealed != null) #isRevealed: isRevealed,
      if (isFlagged != null) #isFlagged: isFlagged,
      if (neighborCount != null) #neighborCount: neighborCount,
    }),
  );
  @override
  MinesweeperCell $make(CopyWithData data) => MinesweeperCell(
    isMine: data.get(#isMine, or: $value.isMine),
    isRevealed: data.get(#isRevealed, or: $value.isRevealed),
    isFlagged: data.get(#isFlagged, or: $value.isFlagged),
    neighborCount: data.get(#neighborCount, or: $value.neighborCount),
  );

  @override
  MinesweeperCellCopyWith<$R2, MinesweeperCell, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MinesweeperCellCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

