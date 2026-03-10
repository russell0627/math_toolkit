import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/algebra_ctrl.dart';
import 'widgets/algebra_auditorium.dart';

class AlgebraScreen extends ConsumerStatefulWidget {
  const AlgebraScreen({super.key});

  @override
  ConsumerState<AlgebraScreen> createState() => _AlgebraScreenState();
}

class _AlgebraScreenState extends ConsumerState<AlgebraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "ALGEBRAIC AUDITORIUM",
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.blueAccent, size: 18),
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(algebraCtrlProvider.notifier).undo();
            },
            tooltip: "REVERSE BUREAUCRATIC DRIFT",
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amberAccent, size: 18),
            onPressed: () {
              HapticFeedback.heavyImpact();
              ref.read(algebraCtrlProvider.notifier).clear();
            },
            tooltip: "RECALIBRATE TOOL",
          ),
        ],
      ),
      body: const AlgebraAuditorium(),
    );
  }
}
