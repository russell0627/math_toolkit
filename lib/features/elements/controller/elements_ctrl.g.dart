// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elements_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ElementsCtrl)
const elementsCtrlProvider = ElementsCtrlProvider._();

final class ElementsCtrlProvider
    extends $NotifierProvider<ElementsCtrl, ElementsState> {
  const ElementsCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'elementsCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$elementsCtrlHash();

  @$internal
  @override
  ElementsCtrl create() => ElementsCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ElementsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ElementsState>(value),
    );
  }
}

String _$elementsCtrlHash() => r'632b9f8713f8c7bff57ac12f3e58519a99ee764b';

abstract class _$ElementsCtrl extends $Notifier<ElementsState> {
  ElementsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ElementsState, ElementsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ElementsState, ElementsState>,
              ElementsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
