// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rotation_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RotationCtrl)
const rotationCtrlProvider = RotationCtrlProvider._();

final class RotationCtrlProvider
    extends $NotifierProvider<RotationCtrl, RotationState> {
  const RotationCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rotationCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rotationCtrlHash();

  @$internal
  @override
  RotationCtrl create() => RotationCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RotationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RotationState>(value),
    );
  }
}

String _$rotationCtrlHash() => r'846a6e6d20a7c392ae0a4181696a757865eadaf9';

abstract class _$RotationCtrl extends $Notifier<RotationState> {
  RotationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RotationState, RotationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RotationState, RotationState>,
              RotationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
