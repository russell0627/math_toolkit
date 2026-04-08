// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slope_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SlopeCtrl)
const slopeCtrlProvider = SlopeCtrlProvider._();

final class SlopeCtrlProvider extends $NotifierProvider<SlopeCtrl, SlopeState> {
  const SlopeCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'slopeCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$slopeCtrlHash();

  @$internal
  @override
  SlopeCtrl create() => SlopeCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SlopeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SlopeState>(value),
    );
  }
}

String _$slopeCtrlHash() => r'318b69f737fedda353feb481444fb566f4314b62';

abstract class _$SlopeCtrl extends $Notifier<SlopeState> {
  SlopeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SlopeState, SlopeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SlopeState, SlopeState>,
              SlopeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
