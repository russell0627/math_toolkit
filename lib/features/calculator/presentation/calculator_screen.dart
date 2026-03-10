import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/calculator_ctrl.dart';
import 'widgets/calculator_display.dart';
import 'widgets/calculator_keypad.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorCtrlProvider);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CALC-UNIT: SN-BUREAU-0001",
          style: GoogleFonts.cutiveMono(
            color: Colors.white24,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "ARITHMETIC CLEARANCE REQUIRED",
              style: GoogleFonts.ebGaramond(
                textStyle: styles.labelSmall.copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CalculatorDisplay(
              display: state.display,
              expression: state.expression,
            ),
            const SizedBox(height: 40),
            const Expanded(
              child: SingleChildScrollView(
                child: CalculatorKeypad(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "TERMINAL SESSION ACTIVE",
              style: styles.labelSmall.copyWith(
                color: Colors.white24,
                fontSize: 10,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
