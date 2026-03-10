// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algebra_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlgebraCtrl)
const algebraCtrlProvider = AlgebraCtrlProvider._();

final class AlgebraCtrlProvider
    extends $NotifierProvider<AlgebraCtrl, AlgebraState> {
  const AlgebraCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'algebraCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$algebraCtrlHash();

  @$internal
  @override
  AlgebraCtrl create() => AlgebraCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlgebraState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlgebraState>(value),
    );
  }
}

String _$algebraCtrlHash() => r'53adde699d8feb283438dddce66664e1b23134a8';

abstract class _$AlgebraCtrl extends $Notifier<AlgebraState> {
  AlgebraState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AlgebraState, AlgebraState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlgebraState, AlgebraState>,
              AlgebraState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
