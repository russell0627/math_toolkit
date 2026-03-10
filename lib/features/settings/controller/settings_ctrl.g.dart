// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsCtrl)
const settingsCtrlProvider = SettingsCtrlProvider._();

final class SettingsCtrlProvider
    extends $NotifierProvider<SettingsCtrl, SettingsState> {
  const SettingsCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsCtrlHash();

  @$internal
  @override
  SettingsCtrl create() => SettingsCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsState>(value),
    );
  }
}

String _$settingsCtrlHash() => r'b78a6c63bbdd6f7acc427488af3d645bb3e28043';

abstract class _$SettingsCtrl extends $Notifier<SettingsState> {
  SettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SettingsState, SettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsState, SettingsState>,
              SettingsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
