import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/minesweeper_ctrl.dart';
import '../models/minesweeper_board.dart';
import 'widgets/minesweeper_grid.dart';

class MinesweeperScreen extends ConsumerWidget {
  MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(minesweeperCtrlProvider);
    final mode = ref.watch(minesweeperControlModeProvider);
    final ctrl = ref.read(minesweeperCtrlProvider.notifier);
    final modeCtrl = ref.read(minesweeperControlModeProvider.notifier);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopConsole(context, ref, board, mode, modeCtrl, styles),
            _buildStatusHeader(board, mode, modeCtrl, styles),
            Expanded(
              child: MinesweeperGrid(
                key: _gridKey,
                board: board,
                onReveal: (r, c) => ctrl.revealCell(r, c),
                onFlag: (r, c) => ctrl.toggleFlag(r, c),
                onChord: (r, c) => ctrl.chordCell(r, c),
              ),
            ),
            _buildBottomControls(mode, modeCtrl),
          ],
        ),
      ),
    );
  }

  final GlobalKey<MinesweeperGridState> _gridKey = GlobalKey<MinesweeperGridState>();

  Widget _buildTopConsole(
    BuildContext context,
    WidgetRef ref,
    MinesweeperBoard board,
    MinesweeperMode mode,
    MinesweeperControlMode modeCtrl,
    dynamic styles,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: Colors.amberAccent.withValues(alpha: 0.2), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.amberAccent, size: 20),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              Text(
                "SUB-SURFACE SCANNER",
                style: GoogleFonts.ebGaramond(
                  textStyle: styles.titleMedium.copyWith(
                    color: Colors.amberAccent,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              _ActionButton(
                label: "CENTER VIEW",
                icon: Icons.filter_center_focus,
                onTap: () => _gridKey.currentState?.resetView(),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: "RECALIBRATE",
                icon: Icons.refresh,
                onTap: () => ref.read(minesweeperCtrlProvider.notifier).reset(),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: "SYSTEM CONFIG",
                icon: Icons.settings,
                onTap: () => _showDifficultyDialog(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(
    MinesweeperBoard board,
    MinesweeperMode mode,
    MinesweeperControlMode modeCtrl,
    dynamic styles,
  ) {
    String status = "SCANNING...";
    Color statusColor = Colors.amberAccent;

    if (board.isGameOver) {
      status = "UNIT COMPROMISED";
      statusColor = Colors.redAccent;
    } else if (board.isWin) {
      status = "SECTOR CLEAR";
      statusColor = Colors.greenAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.amberAccent.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _HudItem(
            label: "STATUS",
            value: status,
            valueColor: statusColor,
          ),
          _HudItem(
            label: "MINES",
            value: "${board.remainingMines}".padLeft(3, '0'),
            valueColor: Colors.amberAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(MinesweeperMode mode, MinesweeperControlMode modeCtrl) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        border: Border(top: BorderSide(color: Colors.amberAccent.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BigModeButton(
              label: "SURVEILLANCE",
              description: "REVEAL CELL",
              isActive: mode == MinesweeperMode.reveal,
              onTap: () => modeCtrl.toggle(),
              accentColor: Colors.amberAccent,
              icon: Icons.search,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _BigModeButton(
              label: "MARKING",
              description: "PLACE FLAG",
              isActive: mode == MinesweeperMode.flag,
              onTap: () => modeCtrl.toggle(),
              accentColor: Colors.blueAccent,
              icon: Icons.flag,
            ),
          ),
        ],
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF222222),
        title: Text(
          "SCAN PARAMETERS",
          style: GoogleFonts.ebGaramond(color: Colors.amberAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _difficultyTile(context, ref, "EASY", MinesweeperDifficulty.easy),
            _difficultyTile(context, ref, "MEDIUM", MinesweeperDifficulty.medium),
            _difficultyTile(context, ref, "HARD", MinesweeperDifficulty.hard),
            _difficultyTile(context, ref, "MASSIVE (100x100)", MinesweeperDifficulty.custom, r: 100, c: 100, m: 1000),
          ],
        ),
      ),
    );
  }

  Widget _difficultyTile(
    BuildContext context,
    WidgetRef ref,
    String label,
    MinesweeperDifficulty difficulty, {
    int? r,
    int? c,
    int? m,
  }) {
    return ListTile(
      title: Text(label, style: GoogleFonts.cutiveMono(color: Colors.white70)),
      onTap: () {
        ref
            .read(minesweeperCtrlProvider.notifier)
            .newGame(
              difficulty: difficulty,
              customRows: r,
              customCols: c,
              customMines: m,
            );
        Navigator.pop(context);
      },
    );
  }
}

class _HudItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _HudItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cutiveMono(fontSize: 10.0, color: Colors.white24, letterSpacing: 1.0),
        ),
        Text(
          value,
          style: GoogleFonts.cutiveMono(
            fontSize: 14.0,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.amberAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.cutiveMono(
              fontSize: 11.0,
              color: Colors.amberAccent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BigModeButton extends StatelessWidget {
  final String label;
  final String description;
  final bool isActive;
  final VoidCallback onTap;
  final Color accentColor;
  final IconData icon;

  const _BigModeButton({
    required this.label,
    required this.description,
    required this.isActive,
    required this.onTap,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? accentColor.withValues(alpha: 0.15) : Colors.black26,
          border: Border.all(
            color: isActive ? accentColor : Colors.white12,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isActive ? accentColor : Colors.white38,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.cutiveMono(
                fontSize: 12.0,
                color: isActive ? accentColor : Colors.white60,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              description,
              style: GoogleFonts.cutiveMono(
                fontSize: 8.0,
                color: isActive ? accentColor.withValues(alpha: 0.7) : Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
