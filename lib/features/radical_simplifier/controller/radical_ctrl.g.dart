// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radical_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RadicalCtrl)
const radicalCtrlProvider = RadicalCtrlProvider._();

final class RadicalCtrlProvider
    extends $NotifierProvider<RadicalCtrl, RadicalState> {
  const RadicalCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'radicalCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$radicalCtrlHash();

  @$internal
  @override
  RadicalCtrl create() => RadicalCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RadicalState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RadicalState>(value),
    );
  }
}

String _$radicalCtrlHash() => r'7c57785f963e1533c7a762137f80ca8064f07e46';

abstract class _$RadicalCtrl extends $Notifier<RadicalState> {
  RadicalState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RadicalState, RadicalState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RadicalState, RadicalState>,
              RadicalState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
