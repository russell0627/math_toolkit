// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GridPythagoreanCtrl)
const gridPythagoreanCtrlProvider = GridPythagoreanCtrlProvider._();

final class GridPythagoreanCtrlProvider
    extends $NotifierProvider<GridPythagoreanCtrl, GridPythagoreanState> {
  const GridPythagoreanCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gridPythagoreanCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gridPythagoreanCtrlHash();

  @$internal
  @override
  GridPythagoreanCtrl create() => GridPythagoreanCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GridPythagoreanState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GridPythagoreanState>(value),
    );
  }
}

String _$gridPythagoreanCtrlHash() =>
    r'e564813e96700229efa941e2a786dd291466905b';

abstract class _$GridPythagoreanCtrl extends $Notifier<GridPythagoreanState> {
  GridPythagoreanState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GridPythagoreanState, GridPythagoreanState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GridPythagoreanState, GridPythagoreanState>,
              GridPythagoreanState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
