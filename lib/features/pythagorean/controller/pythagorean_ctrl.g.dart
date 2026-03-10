// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pythagorean_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PythagoreanCtrl)
const pythagoreanCtrlProvider = PythagoreanCtrlProvider._();

final class PythagoreanCtrlProvider
    extends $NotifierProvider<PythagoreanCtrl, PythagoreanState> {
  const PythagoreanCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pythagoreanCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pythagoreanCtrlHash();

  @$internal
  @override
  PythagoreanCtrl create() => PythagoreanCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PythagoreanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PythagoreanState>(value),
    );
  }
}

String _$pythagoreanCtrlHash() => r'8f5bdda419c65486d0a13ecffa15b40f01ace4cf';

abstract class _$PythagoreanCtrl extends $Notifier<PythagoreanState> {
  PythagoreanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PythagoreanState, PythagoreanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PythagoreanState, PythagoreanState>,
              PythagoreanState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
