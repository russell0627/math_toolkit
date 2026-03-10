import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/minesweeper_ctrl.dart';
import '../../models/minesweeper_board.dart';

class MinesweeperGrid extends ConsumerStatefulWidget {
  final MinesweeperBoard board;
  final Function(int r, int c) onReveal;
  final Function(int r, int c) onFlag;
  final Function(int r, int c) onChord;

  const MinesweeperGrid({
    super.key,
    required this.board,
    required this.onReveal,
    required this.onFlag,
    required this.onChord,
  });

  @override
  ConsumerState<MinesweeperGrid> createState() => MinesweeperGridState();
}

class MinesweeperGridState extends ConsumerState<MinesweeperGrid> {
  final TransformationController _transformationController = TransformationController();
  static const double _cellSize = 40.0;
  Point<int>? _highlightedCell;
  Timer? _highlightTimer;

  @override
  void dispose() {
    _transformationController.dispose();
    _highlightTimer?.cancel();
    super.dispose();
  }

  void resetView() {
    _transformationController.value = Matrix4.identity();
  }

  void _setHighlight(int r, int c) {
    setState(() {
      _highlightedCell = Point(r, c);
    });
    _highlightTimer?.cancel();
    _highlightTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _highlightedCell = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(minesweeperControlModeProvider);

    return GestureDetector(
      onTapUp: (details) {
        final position = _transformationController.toScene(details.localPosition);
        final r = (position.dy / _cellSize).floor();
        final c = (position.dx / _cellSize).floor();

        if (r >= 0 && r < widget.board.rows && c >= 0 && c < widget.board.cols) {
          final cell = widget.board.grid[r][c];

          if (cell.isRevealed) {
            _setHighlight(r, c);
            widget.onChord(r, c);
          } else {
            // Act based on mode
            if (mode == MinesweeperMode.reveal) {
              widget.onReveal(r, c);
            } else {
              widget.onFlag(r, c);
            }
          }
        }
      },
      onLongPressStart: (details) {
        final position = _transformationController.toScene(details.localPosition);
        final r = (position.dy / _cellSize).floor();
        final c = (position.dx / _cellSize).floor();
        if (r >= 0 && r < widget.board.rows && c >= 0 && c < widget.board.cols) {
          widget.onFlag(r, c);
        }
      },
      child: InteractiveViewer(
        transformationController: _transformationController,
        constrained: false,
        boundaryMargin: const EdgeInsets.all(400),
        minScale: 0.1,
        maxScale: 4.0,
        child: CustomPaint(
          size: Size(widget.board.cols * _cellSize, widget.board.rows * _cellSize),
          painter: _GridPainter(
            board: widget.board,
            cellSize: _cellSize,
            highlightedCell: _highlightedCell,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final MinesweeperBoard board;
  final double cellSize;
  final Point<int>? highlightedCell;

  _GridPainter({
    required this.board,
    required this.cellSize,
    this.highlightedCell,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < board.rows; r++) {
      for (int c = 0; c < board.cols; c++) {
        final cell = board.grid[r][c];
        final rect = Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize);

        // Cell background
        final paint = Paint()
          ..color = cell.isRevealed ? Colors.black.withValues(alpha: 0.5) : Colors.amberAccent.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);

        // Cell border
        paint
          ..color = Colors.amberAccent.withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawRect(rect, paint);

        // Highlight neighbor focus
        if (highlightedCell != null) {
          final dr = (r - highlightedCell!.x).abs();
          final dc = (c - highlightedCell!.y).abs();
          if (dr <= 1 && dc <= 1 && !(dr == 0 && dc == 0)) {
            paint
              ..color = Colors.amberAccent.withValues(alpha: 0.3)
              ..style = PaintingStyle.fill;
            canvas.drawRect(rect, paint);
          }
        }

        if (cell.isRevealed) {
          if (cell.isMine) {
            _drawMine(canvas, rect);
          } else if (cell.neighborCount > 0) {
            _drawNumber(canvas, rect, cell.neighborCount);
          }
        } else if (cell.isFlagged) {
          _drawFlag(canvas, rect);
        }
      }
    }
  }

  void _drawMine(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(rect.center, rect.width * 0.3, paint);

    // Glow
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(rect.center, rect.width * 0.35, paint);
  }

  void _drawFlag(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(rect.center.dx - 5, rect.center.dy + 10)
      ..lineTo(rect.center.dx - 5, rect.center.dy - 10)
      ..lineTo(rect.center.dx + 10, rect.center.dy - 5)
      ..lineTo(rect.center.dx - 5, rect.center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawNumber(Canvas canvas, Rect rect, int count) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: count.toString(),
        style: GoogleFonts.cutiveMono(
          color: _getNumberColor(count),
          fontSize: cellSize * 0.6,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: _getNumberColor(count).withValues(alpha: 0.5),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      rect.center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  Color _getNumberColor(int count) {
    switch (count) {
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.greenAccent;
      case 3:
        return Colors.redAccent;
      case 4:
        return Colors.purpleAccent;
      case 5:
        return Colors.orangeAccent;
      case 6:
        return Colors.cyanAccent;
      case 7:
        return Colors.pinkAccent;
      case 8:
        return Colors.white;
      default:
        return Colors.white;
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.board != board || oldDelegate.highlightedCell != highlightedCell;
  }
}
