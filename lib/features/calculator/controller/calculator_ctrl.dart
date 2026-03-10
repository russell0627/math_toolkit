import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_ctrl.g.dart';

@riverpod
class CalculatorCtrl extends _$CalculatorCtrl {
  @override
  CalculatorState build() {
    return const CalculatorState(display: '0');
  }

  void addDigit(String digit) {
    if (state.display == '0' || state.shouldResetDisplay) {
      state = state.copyWith(display: digit, shouldResetDisplay: false);
    } else {
      state = state.copyWith(display: state.display + digit);
    }
  }

  void addDecimal() {
    if (state.shouldResetDisplay) {
      state = state.copyWith(display: '0.', shouldResetDisplay: false);
      return;
    }
    if (!state.display.contains('.')) {
      state = state.copyWith(display: '${state.display}.');
    }
  }

  void setOperator(String operator) {
    if (state.operator != null && !state.shouldResetDisplay) {
      calculate();
    }
    state = state.copyWith(
      previousValue: double.tryParse(state.display),
      operator: operator,
      shouldResetDisplay: true,
      expression: '${state.display} $operator',
    );
  }

  void calculate() {
    if (state.previousValue == null || state.operator == null) return;

    final current = double.tryParse(state.display) ?? 0;
    final previous = state.previousValue!;
    double result = 0;

    switch (state.operator) {
      case '+':
        result = previous + current;
      case '-':
        result = previous - current;
      case '*':
        result = previous * current;
      case '/':
        result = current == 0 ? 0 : previous / current;
    }

    final resultString = _formatResult(result);
    state = state.copyWith(
      display: resultString,
      previousValue: null,
      operator: null,
      shouldResetDisplay: true,
      expression: '${_formatResult(previous)} ${state.operator} ${_formatResult(current)} =',
    );
  }

  void clear() {
    state = const CalculatorState(display: '0');
  }

  void backspace() {
    if (state.shouldResetDisplay) return;
    if (state.display.length <= 1) {
      state = state.copyWith(display: '0');
    } else {
      state = state.copyWith(display: state.display.substring(0, state.display.length - 1));
    }
  }

  String _formatResult(double value) {
    if (value == value.toInt().toDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }
}

class CalculatorState {
  final String display;
  final String? expression;
  final double? previousValue;
  final String? operator;
  final bool shouldResetDisplay;

  const CalculatorState({
    required this.display,
    this.expression,
    this.previousValue,
    this.operator,
    this.shouldResetDisplay = false,
  });

  CalculatorState copyWith({
    String? display,
    String? expression,
    double? previousValue,
    String? operator,
    bool? shouldResetDisplay,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      previousValue: previousValue ?? this.previousValue,
      operator: operator ?? this.operator,
      shouldResetDisplay: shouldResetDisplay ?? this.shouldResetDisplay,
    );
  }
}
