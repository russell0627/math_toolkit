import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../keypad/tactile_keypad_button.dart';
import '../../controller/calculator_ctrl.dart';

class CalculatorKeypad extends ConsumerWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(calculatorCtrlProvider.notifier);
    final fontStyle = GoogleFonts.cutiveMono();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.1,
        children: [
        // Row 1
        _buildKey('7', onTap: () => ctrl.addDigit('7'), fontStyle: fontStyle),
        _buildKey('8', onTap: () => ctrl.addDigit('8'), fontStyle: fontStyle),
        _buildKey('9', onTap: () => ctrl.addDigit('9'), fontStyle: fontStyle),
        _buildKey(
          '/',
          onTap: () => ctrl.setOperator('/'),
          fontStyle: fontStyle,
          isAction: true,
          color: Colors.amberAccent,
        ),

        // Row 2
        _buildKey('4', onTap: () => ctrl.addDigit('4'), fontStyle: fontStyle),
        _buildKey('5', onTap: () => ctrl.addDigit('5'), fontStyle: fontStyle),
        _buildKey('6', onTap: () => ctrl.addDigit('6'), fontStyle: fontStyle),
        _buildKey(
          '*',
          onTap: () => ctrl.setOperator('*'),
          fontStyle: fontStyle,
          isAction: true,
          color: Colors.amberAccent,
        ),

        // Row 3
        _buildKey('1', onTap: () => ctrl.addDigit('1'), fontStyle: fontStyle),
        _buildKey('2', onTap: () => ctrl.addDigit('2'), fontStyle: fontStyle),
        _buildKey('3', onTap: () => ctrl.addDigit('3'), fontStyle: fontStyle),
        _buildKey(
          '-',
          onTap: () => ctrl.setOperator('-'),
          fontStyle: fontStyle,
          isAction: true,
          color: Colors.amberAccent,
        ),

        // Row 4
        _buildKey('C', onTap: () => ctrl.clear(), fontStyle: fontStyle, isAction: true, color: Colors.redAccent),
        _buildKey('0', onTap: () => ctrl.addDigit('0'), fontStyle: fontStyle),
        _buildKey('=', onTap: () => ctrl.calculate(), fontStyle: fontStyle, isAction: true, color: Colors.greenAccent),
        _buildKey(
          '+',
          onTap: () => ctrl.setOperator('+'),
          fontStyle: fontStyle,
          isAction: true,
        ),
      ],
    ),
  );
}

  Widget _buildKey(
    String label, {
    required VoidCallback onTap,
    required TextStyle fontStyle,
    bool isAction = false,
    Color? color,
  }) {
    return TactileKeypadButton(
      label: label,
      onTap: onTap,
      fontStyle: fontStyle,
      isAction: isAction,
      color: color,
    );
  }
}
