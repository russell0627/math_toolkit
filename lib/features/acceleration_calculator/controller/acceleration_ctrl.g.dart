// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acceleration_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccelerationCtrl)
const accelerationCtrlProvider = AccelerationCtrlProvider._();

final class AccelerationCtrlProvider
    extends $NotifierProvider<AccelerationCtrl, AccelerationState> {
  const AccelerationCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accelerationCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accelerationCtrlHash();

  @$internal
  @override
  AccelerationCtrl create() => AccelerationCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccelerationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccelerationState>(value),
    );
  }
}

String _$accelerationCtrlHash() => r'e80bebbf068729576e0ccedbc689e4e72ff9528f';

abstract class _$AccelerationCtrl extends $Notifier<AccelerationState> {
  AccelerationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AccelerationState, AccelerationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccelerationState, AccelerationState>,
              AccelerationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
