// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronizer_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SynchronizerCtrl)
const synchronizerCtrlProvider = SynchronizerCtrlProvider._();

final class SynchronizerCtrlProvider
    extends $NotifierProvider<SynchronizerCtrl, SyncState> {
  const SynchronizerCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'synchronizerCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$synchronizerCtrlHash();

  @$internal
  @override
  SynchronizerCtrl create() => SynchronizerCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$synchronizerCtrlHash() => r'45e256ca8836c942d1338714f3e26b7dccbca3aa';

abstract class _$SynchronizerCtrl extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
