// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efficiency_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EfficiencyCtrl)
const efficiencyCtrlProvider = EfficiencyCtrlProvider._();

final class EfficiencyCtrlProvider
    extends $NotifierProvider<EfficiencyCtrl, EfficiencyState> {
  const EfficiencyCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'efficiencyCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$efficiencyCtrlHash();

  @$internal
  @override
  EfficiencyCtrl create() => EfficiencyCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EfficiencyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EfficiencyState>(value),
    );
  }
}

String _$efficiencyCtrlHash() => r'7e8b893ab0c6c6051fcd3f9a2597e167055fb722';

abstract class _$EfficiencyCtrl extends $Notifier<EfficiencyState> {
  EfficiencyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<EfficiencyState, EfficiencyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EfficiencyState, EfficiencyState>,
              EfficiencyState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
