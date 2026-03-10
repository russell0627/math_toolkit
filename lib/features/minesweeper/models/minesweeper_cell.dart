import 'package:dart_mappable/dart_mappable.dart';

part 'minesweeper_cell.mapper.dart';

@MappableClass()
class MinesweeperCell with MinesweeperCellMappable {
  final bool isMine;
  final bool isRevealed;
  final bool isFlagged;
  final int neighborCount;

  const MinesweeperCell({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.neighborCount = 0,
  });

  MinesweeperCell reveal() => copyWith(isRevealed: true);
  MinesweeperCell toggleFlag() => copyWith(isFlagged: !isFlagged);
}
