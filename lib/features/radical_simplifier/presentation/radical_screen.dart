import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/presentation/widgets/bureau_atmosphere.dart';
import '../controller/radical_ctrl.dart';
import 'radical_view.dart';

class RadicalScreen extends ConsumerWidget {
  const RadicalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(radicalCtrlProvider.notifier);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BureauAtmosphere(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopConsole(context, ctrl, styles),
              const Expanded(child: RadicalView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopConsole(BuildContext context, RadicalCtrl ctrl, dynamic styles) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: Colors.purpleAccent.withValues(alpha: 0.2), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.purpleAccent, size: 20),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              Text(
                "RADICAL REDUCTION UNIT (RAD-03)",
                style: GoogleFonts.ebGaramond(
                  textStyle: styles.titleMedium.copyWith(
                    color: Colors.purpleAccent,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: ctrl.reset,
            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.purpleAccent, size: 18),
            tooltip: "PURGE BUFFER",
          ),
        ],
      ),
    );
  }
}
