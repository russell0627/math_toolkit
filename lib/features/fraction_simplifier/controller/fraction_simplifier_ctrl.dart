import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fraction_simplifier_ctrl.g.dart';

@riverpod
class FractionSimplifierCtrl extends _$FractionSimplifierCtrl {
  @override
  FractionState build() {
    return const FractionState();
  }

  void setNumerator(String value) {
    state = state.copyWith(numerator: int.tryParse(value));
  }

  void setDenominator(String value) {
    state = state.copyWith(denominator: int.tryParse(value));
  }

  void simplify() {
    if (state.numerator == null || state.denominator == null || state.denominator == 0) {
      return;
    }

    final div = _gcd(state.numerator!.abs(), state.denominator!.abs());

    state = state.copyWith(
      simplifiedNumerator: state.numerator! ~/ div,
      simplifiedDenominator: state.denominator! ~/ div,
      isSimplified: true,
    );
  }

  void clear() {
    state = const FractionState();
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }
}

class FractionState {
  final int? numerator;
  final int? denominator;
  final int? simplifiedNumerator;
  final int? simplifiedDenominator;
  final bool isSimplified;

  const FractionState({
    this.numerator,
    this.denominator,
    this.simplifiedNumerator,
    this.simplifiedDenominator,
    this.isSimplified = false,
  });

  FractionState copyWith({
    int? numerator,
    int? denominator,
    int? simplifiedNumerator,
    int? simplifiedDenominator,
    bool? isSimplified,
  }) {
    return FractionState(
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
      simplifiedNumerator: simplifiedNumerator ?? this.simplifiedNumerator,
      simplifiedDenominator: simplifiedDenominator ?? this.simplifiedDenominator,
      isSimplified: isSimplified ?? this.isSimplified,
    );
  }
}
