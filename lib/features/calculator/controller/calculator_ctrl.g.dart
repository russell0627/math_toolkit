// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculator_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CalculatorCtrl)
const calculatorCtrlProvider = CalculatorCtrlProvider._();

final class CalculatorCtrlProvider
    extends $NotifierProvider<CalculatorCtrl, CalculatorState> {
  const CalculatorCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calculatorCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calculatorCtrlHash();

  @$internal
  @override
  CalculatorCtrl create() => CalculatorCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalculatorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalculatorState>(value),
    );
  }
}

String _$calculatorCtrlHash() => r'd1619da2d49e6bec9f92643cc9da73edeea900f2';

abstract class _$CalculatorCtrl extends $Notifier<CalculatorState> {
  CalculatorState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CalculatorState, CalculatorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CalculatorState, CalculatorState>,
              CalculatorState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
