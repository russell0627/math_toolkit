import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../calculator/controller/calculator_ctrl.dart';
import '../../../calculator/presentation/widgets/calculator_display.dart';
import '../../../calculator/presentation/widgets/calculator_keypad.dart';

class MiniCalculatorView extends ConsumerWidget {
  const MiniCalculatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorCtrlProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
      ),
      child: Column(
        children: [
          CalculatorDisplay(
            display: state.display,
            expression: state.expression,
          ),
          const SizedBox(height: 12),
          const Expanded(
            child: SingleChildScrollView(
              child: CalculatorKeypad(),
            ),
          ),
        ],
      ),
    );
  }
}
