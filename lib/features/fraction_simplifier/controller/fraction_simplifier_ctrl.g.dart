// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fraction_simplifier_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FractionSimplifierCtrl)
const fractionSimplifierCtrlProvider = FractionSimplifierCtrlProvider._();

final class FractionSimplifierCtrlProvider
    extends $NotifierProvider<FractionSimplifierCtrl, FractionState> {
  const FractionSimplifierCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fractionSimplifierCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fractionSimplifierCtrlHash();

  @$internal
  @override
  FractionSimplifierCtrl create() => FractionSimplifierCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FractionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FractionState>(value),
    );
  }
}

String _$fractionSimplifierCtrlHash() =>
    r'd09056e9406fc9e47a805640602e199cf4ccd3f6';

abstract class _$FractionSimplifierCtrl extends $Notifier<FractionState> {
  FractionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FractionState, FractionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FractionState, FractionState>,
              FractionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
