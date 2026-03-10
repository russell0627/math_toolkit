import 'dart:math';
import 'package:dart_mappable/dart_mappable.dart';
import 'minesweeper_cell.dart';

part 'minesweeper_board.mapper.dart';

@MappableClass()
class MinesweeperBoard with MinesweeperBoardMappable {
  final int rows;
  final int cols;
  final int mineCount;
  final List<List<MinesweeperCell>> grid;
  final bool isGameOver;
  final bool isWin;
  final bool initialized;

  const MinesweeperBoard({
    required this.rows,
    required this.cols,
    required this.mineCount,
    required this.grid,
    this.isGameOver = false,
    this.isWin = false,
    this.initialized = false,
  });

  static MinesweeperBoard create({
    required int rows,
    required int cols,
    required int mineCount,
  }) {
    // Initialize empty grid without mines
    final List<List<MinesweeperCell>> grid = List.generate(
      rows,
      (r) => List.generate(cols, (c) => const MinesweeperCell()),
    );

    return MinesweeperBoard(
      rows: rows,
      cols: cols,
      grid: grid,
      mineCount: mineCount,
      initialized: false,
    );
  }

  int get flagCount => grid.expand((row) => row).where((cell) => cell.isFlagged).length;

  int get remainingMines => mineCount - flagCount;

  MinesweeperBoard revealCell(int r, int c) {
    if (isGameOver || isWin || grid[r][c].isRevealed || grid[r][c].isFlagged) {
      return this;
    }

    MinesweeperBoard board = this;
    if (!initialized) {
      board = _initialize(r, c);
    }

    if (board.grid[r][c].isMine) {
      // Game over - reveal all mines
      final newGrid = board.grid.map((row) => row.map((cell) => cell.isMine ? cell.reveal() : cell).toList()).toList();
      return board.copyWith(grid: newGrid, isGameOver: true);
    }

    final newGrid = board.grid.map((row) => row.toList()).toList();
    _floodFillReveal(newGrid, r, c);

    // Check win condition
    bool win = true;
    for (var row in newGrid) {
      for (var cell in row) {
        if (!cell.isMine && !cell.isRevealed) {
          win = false;
          break;
        }
      }
      if (!win) break;
    }

    return board.copyWith(grid: newGrid, isWin: win);
  }

  MinesweeperBoard _initialize(int startR, int startC) {
    final List<List<MinesweeperCell>> newGrid = grid.map((row) => row.toList()).toList();

    // Place mines
    final random = Random();
    int placedMines = 0;
    while (placedMines < mineCount) {
      final r = random.nextInt(rows);
      final c = random.nextInt(cols);

      // Don't place mine in a 3x3 area around the start click to ensure a starting area
      bool isSafeZone = (r >= startR - 1 && r <= startR + 1) && (c >= startC - 1 && c <= startC + 1);

      if (!newGrid[r][c].isMine && !isSafeZone) {
        newGrid[r][c] = newGrid[r][c].copyWith(isMine: true);
        placedMines++;
      }
    }

    // Calculate neighbor counts
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!newGrid[r][c].isMine) {
          int count = 0;
          for (int dr = -1; dr <= 1; dr++) {
            for (int dc = -1; dc <= 1; dc++) {
              if (dr == 0 && dc == 0) continue;
              final nr = r + dr;
              final nc = c + dc;
              if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && newGrid[nr][nc].isMine) {
                count++;
              }
            }
          }
          newGrid[r][c] = newGrid[r][c].copyWith(neighborCount: count);
        }
      }
    }

    return copyWith(grid: newGrid, initialized: true);
  }

  void _floodFillReveal(List<List<MinesweeperCell>> grid, int r, int c) {
    if (r < 0 || r >= rows || c < 0 || c >= cols || grid[r][c].isRevealed || grid[r][c].isFlagged) {
      return;
    }

    grid[r][c] = grid[r][c].reveal();

    if (grid[r][c].neighborCount == 0) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;
          _floodFillReveal(grid, r + dr, c + dc);
        }
      }
    }
  }

  MinesweeperBoard toggleFlag(int r, int c) {
    if (isGameOver || isWin || grid[r][c].isRevealed) {
      return this;
    }

    final newGrid = grid.map((row) => row.toList()).toList();
    newGrid[r][c] = newGrid[r][c].toggleFlag();

    return copyWith(grid: newGrid);
  }

  MinesweeperBoard chordCell(int r, int c) {
    if (isGameOver || isWin || !grid[r][c].isRevealed || grid[r][c].neighborCount == 0) {
      return this;
    }

    // Count flags around the cell
    int flags = 0;
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = r + dr;
        final nc = c + dc;
        if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && grid[nr][nc].isFlagged) {
          flags++;
        }
      }
    }

    if (flags != grid[r][c].neighborCount) {
      return this;
    }

    // Reveal all unflagged, unrevealed neighbors
    MinesweeperBoard current = this;
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = r + dr;
        final nc = c + dc;
        if (nr >= 0 &&
            nr < rows &&
            nc >= 0 &&
            nc < cols &&
            !current.grid[nr][nc].isFlagged &&
            !current.grid[nr][nc].isRevealed) {
          current = current.revealCell(nr, nc);
          if (current.isGameOver) return current;
        }
      }
    }

    return current;
  }
}
