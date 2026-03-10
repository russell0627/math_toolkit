import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/minesweeper_board.dart';

part 'minesweeper_ctrl.g.dart';

enum MinesweeperDifficulty {
  easy(8, 8, 10),
  medium(16, 16, 40),
  hard(16, 30, 99),
  custom(0, 0, 0)
  ;

  final int rows;
  final int cols;
  final int mines;

  const MinesweeperDifficulty(this.rows, this.cols, this.mines);
}

@riverpod
class MinesweeperCtrl extends _$MinesweeperCtrl {
  MinesweeperDifficulty _currentDifficulty = MinesweeperDifficulty.easy;
  int? _currentRows;
  int? _currentCols;
  int? _currentMines;

  @override
  MinesweeperBoard build() {
    return MinesweeperBoard.create(
      rows: MinesweeperDifficulty.easy.rows,
      cols: MinesweeperDifficulty.easy.cols,
      mineCount: MinesweeperDifficulty.easy.mines,
    );
  }

  void newGame({
    MinesweeperDifficulty difficulty = MinesweeperDifficulty.easy,
    int? customRows,
    int? customCols,
    int? customMines,
  }) {
    _currentDifficulty = difficulty;
    _currentRows = customRows;
    _currentCols = customCols;
    _currentMines = customMines;

    state = MinesweeperBoard.create(
      rows: difficulty == MinesweeperDifficulty.custom ? customRows! : difficulty.rows,
      cols: difficulty == MinesweeperDifficulty.custom ? customCols! : difficulty.cols,
      mineCount: difficulty == MinesweeperDifficulty.custom ? customMines! : difficulty.mines,
    );
  }

  void reset() {
    newGame(
      difficulty: _currentDifficulty,
      customRows: _currentRows,
      customCols: _currentCols,
      customMines: _currentMines,
    );
  }

  void revealCell(int r, int c) {
    state = state.revealCell(r, c);
  }

  void toggleFlag(int r, int c) {
    state = state.toggleFlag(r, c);
  }

  void chordCell(int r, int c) {
    state = state.chordCell(r, c);
  }
}

@riverpod
class MinesweeperControlMode extends _$MinesweeperControlMode {
  @override
  MinesweeperMode build() => MinesweeperMode.reveal;

  void toggle() {
    state = state == MinesweeperMode.reveal ? MinesweeperMode.flag : MinesweeperMode.reveal;
  }
}

enum MinesweeperMode {
  reveal,
  flag,
}
