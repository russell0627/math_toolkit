// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cipher_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CipherCtrl)
const cipherCtrlProvider = CipherCtrlProvider._();

final class CipherCtrlProvider
    extends $NotifierProvider<CipherCtrl, CipherState> {
  const CipherCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cipherCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cipherCtrlHash();

  @$internal
  @override
  CipherCtrl create() => CipherCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CipherState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CipherState>(value),
    );
  }
}

String _$cipherCtrlHash() => r'60139d13241bde0460fc68639eeade33e9bdb920';

abstract class _$CipherCtrl extends $Notifier<CipherState> {
  CipherState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CipherState, CipherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CipherState, CipherState>,
              CipherState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
