import 'dart:math' as math;

import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/synchronizer_ctrl.dart';

class SynchronizerScreen extends ConsumerStatefulWidget {
  const SynchronizerScreen({super.key});

  @override
  ConsumerState<SynchronizerScreen> createState() => _SynchronizerScreenState();
}

class _SynchronizerScreenState extends ConsumerState<SynchronizerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(synchronizerCtrlProvider);
    final ctrl = ref.read(synchronizerCtrlProvider.notifier);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SYNC-UNIT: SN-BUREAU-0005",
          style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 12, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "TEMPORAL ALIGNMENT AUTHORIZED",
              style: GoogleFonts.ebGaramond(
                textStyle: styles.labelSmall.copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Type Selector
            Row(
              children: [
                _TypeButton(
                  label: "LENGTH",
                  isSelected: state.type == SyncType.length,
                  onTap: () => ctrl.setType(SyncType.length),
                ),
                const SizedBox(width: 8),
                _TypeButton(
                  label: "MASS",
                  isSelected: state.type == SyncType.mass,
                  onTap: () => ctrl.setType(SyncType.mass),
                ),
                const SizedBox(width: 8),
                _TypeButton(
                  label: "TIME",
                  isSelected: state.type == SyncType.time,
                  onTap: () => ctrl.setType(SyncType.time),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Oscilloscope
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF050F05),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2), width: 2),
              ),
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: OscilloscopePainter(
                      progress: _animController.value,
                      magnitude: math.min(state.inputValue.abs() / 100, 1.0),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Input
            TextField(
              controller: _inputController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 32),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: "BASE METRIC",
                labelStyle: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.3),
                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
              onChanged: (val) => ctrl.setInput(val),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.swap_vert, color: Colors.amberAccent, size: 32),
            const SizedBox(height: 24),
            // Result
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Text(
                    "CONVERTED CALIBRATION",
                    style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: 10),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.resultValue.toStringAsFixed(2),
                        style: GoogleFonts.cutiveMono(
                          color: Colors.amberAccent,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          shadows: [const Shadow(color: Colors.amberAccent, blurRadius: 10)],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          state.unit,
                          style: GoogleFonts.cutiveMono(color: Colors.amberAccent.withValues(alpha: 0.5), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "SYNCHRONIZATION ACTIVE",
              style: styles.labelSmall.copyWith(color: Colors.white24, fontSize: 10, letterSpacing: 4),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.greenAccent.withValues(alpha: 0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? Colors.greenAccent : Colors.white10),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.cutiveMono(
              color: isSelected ? Colors.greenAccent : Colors.white24,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class OscilloscopePainter extends CustomPainter {
  final double progress;
  final double magnitude;

  OscilloscopePainter({required this.progress, required this.magnitude});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerY = size.height / 2;

    for (var x = 0.0; x < size.width; x++) {
      final t = (x / size.width) * 4 * math.pi + (progress * 2 * math.pi);
      final y = centerY + math.sin(t) * (20 + (magnitude * 30));
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Glow
    canvas.drawPath(path, paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    canvas.drawPath(
      path,
      paint
        ..maskFilter = null
        ..color = Colors.greenAccent,
    );

    // Grid lines
    final gridPaint = Paint()..color = Colors.white.withValues(alpha: 0.05);
    for (var i = 1; i < 5; i++) {
      canvas.drawLine(Offset(0, size.height * i / 5), Offset(size.width, size.height * i / 5), gridPaint);
      canvas.drawLine(Offset(size.width * i / 5, 0), Offset(size.width * i / 5, size.height), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OscilloscopePainter oldDelegate) {
    return true;
  }
}
