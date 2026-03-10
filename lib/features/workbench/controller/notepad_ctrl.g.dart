// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notepad_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotepadCtrl)
const notepadCtrlProvider = NotepadCtrlProvider._();

final class NotepadCtrlProvider extends $NotifierProvider<NotepadCtrl, String> {
  const NotepadCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notepadCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notepadCtrlHash();

  @$internal
  @override
  NotepadCtrl create() => NotepadCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$notepadCtrlHash() => r'8e7e09a1fd7822572c260d298b895608b03df116';

abstract class _$NotepadCtrl extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
