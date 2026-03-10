// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'minesweeper_board.dart';

class MinesweeperBoardMapper extends ClassMapperBase<MinesweeperBoard> {
  MinesweeperBoardMapper._();

  static MinesweeperBoardMapper? _instance;
  static MinesweeperBoardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MinesweeperBoardMapper._());
      MinesweeperCellMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MinesweeperBoard';

  static int _$rows(MinesweeperBoard v) => v.rows;
  static const Field<MinesweeperBoard, int> _f$rows = Field('rows', _$rows);
  static int _$cols(MinesweeperBoard v) => v.cols;
  static const Field<MinesweeperBoard, int> _f$cols = Field('cols', _$cols);
  static int _$mineCount(MinesweeperBoard v) => v.mineCount;
  static const Field<MinesweeperBoard, int> _f$mineCount = Field(
    'mineCount',
    _$mineCount,
  );
  static List<List<MinesweeperCell>> _$grid(MinesweeperBoard v) => v.grid;
  static const Field<MinesweeperBoard, List<List<MinesweeperCell>>> _f$grid =
      Field('grid', _$grid);
  static bool _$isGameOver(MinesweeperBoard v) => v.isGameOver;
  static const Field<MinesweeperBoard, bool> _f$isGameOver = Field(
    'isGameOver',
    _$isGameOver,
    opt: true,
    def: false,
  );
  static bool _$isWin(MinesweeperBoard v) => v.isWin;
  static const Field<MinesweeperBoard, bool> _f$isWin = Field(
    'isWin',
    _$isWin,
    opt: true,
    def: false,
  );
  static bool _$initialized(MinesweeperBoard v) => v.initialized;
  static const Field<MinesweeperBoard, bool> _f$initialized = Field(
    'initialized',
    _$initialized,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<MinesweeperBoard> fields = const {
    #rows: _f$rows,
    #cols: _f$cols,
    #mineCount: _f$mineCount,
    #grid: _f$grid,
    #isGameOver: _f$isGameOver,
    #isWin: _f$isWin,
    #initialized: _f$initialized,
  };

  static MinesweeperBoard _instantiate(DecodingData data) {
    return MinesweeperBoard(
      rows: data.dec(_f$rows),
      cols: data.dec(_f$cols),
      mineCount: data.dec(_f$mineCount),
      grid: data.dec(_f$grid),
      isGameOver: data.dec(_f$isGameOver),
      isWin: data.dec(_f$isWin),
      initialized: data.dec(_f$initialized),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MinesweeperBoard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MinesweeperBoard>(map);
  }

  static MinesweeperBoard fromJson(String json) {
    return ensureInitialized().decodeJson<MinesweeperBoard>(json);
  }
}

mixin MinesweeperBoardMappable {
  String toJson() {
    return MinesweeperBoardMapper.ensureInitialized()
        .encodeJson<MinesweeperBoard>(this as MinesweeperBoard);
  }

  Map<String, dynamic> toMap() {
    return MinesweeperBoardMapper.ensureInitialized()
        .encodeMap<MinesweeperBoard>(this as MinesweeperBoard);
  }

  MinesweeperBoardCopyWith<MinesweeperBoard, MinesweeperBoard, MinesweeperBoard>
  get copyWith =>
      _MinesweeperBoardCopyWithImpl<MinesweeperBoard, MinesweeperBoard>(
        this as MinesweeperBoard,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MinesweeperBoardMapper.ensureInitialized().stringifyValue(
      this as MinesweeperBoard,
    );
  }

  @override
  bool operator ==(Object other) {
    return MinesweeperBoardMapper.ensureInitialized().equalsValue(
      this as MinesweeperBoard,
      other,
    );
  }

  @override
  int get hashCode {
    return MinesweeperBoardMapper.ensureInitialized().hashValue(
      this as MinesweeperBoard,
    );
  }
}

extension MinesweeperBoardValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MinesweeperBoard, $Out> {
  MinesweeperBoardCopyWith<$R, MinesweeperBoard, $Out>
  get $asMinesweeperBoard =>
      $base.as((v, t, t2) => _MinesweeperBoardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MinesweeperBoardCopyWith<$R, $In extends MinesweeperBoard, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    List<MinesweeperCell>,
    ObjectCopyWith<$R, List<MinesweeperCell>, List<MinesweeperCell>>
  >
  get grid;
  $R call({
    int? rows,
    int? cols,
    int? mineCount,
    List<List<MinesweeperCell>>? grid,
    bool? isGameOver,
    bool? isWin,
    bool? initialized,
  });
  MinesweeperBoardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MinesweeperBoardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MinesweeperBoard, $Out>
    implements MinesweeperBoardCopyWith<$R, MinesweeperBoard, $Out> {
  _MinesweeperBoardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MinesweeperBoard> $mapper =
      MinesweeperBoardMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    List<MinesweeperCell>,
    ObjectCopyWith<$R, List<MinesweeperCell>, List<MinesweeperCell>>
  >
  get grid => ListCopyWith(
    $value.grid,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(grid: v),
  );
  @override
  $R call({
    int? rows,
    int? cols,
    int? mineCount,
    List<List<MinesweeperCell>>? grid,
    bool? isGameOver,
    bool? isWin,
    bool? initialized,
  }) => $apply(
    FieldCopyWithData({
      if (rows != null) #rows: rows,
      if (cols != null) #cols: cols,
      if (mineCount != null) #mineCount: mineCount,
      if (grid != null) #grid: grid,
      if (isGameOver != null) #isGameOver: isGameOver,
      if (isWin != null) #isWin: isWin,
      if (initialized != null) #initialized: initialized,
    }),
  );
  @override
  MinesweeperBoard $make(CopyWithData data) => MinesweeperBoard(
    rows: data.get(#rows, or: $value.rows),
    cols: data.get(#cols, or: $value.cols),
    mineCount: data.get(#mineCount, or: $value.mineCount),
    grid: data.get(#grid, or: $value.grid),
    isGameOver: data.get(#isGameOver, or: $value.isGameOver),
    isWin: data.get(#isWin, or: $value.isWin),
    initialized: data.get(#initialized, or: $value.initialized),
  );

  @override
  MinesweeperBoardCopyWith<$R2, MinesweeperBoard, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MinesweeperBoardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

