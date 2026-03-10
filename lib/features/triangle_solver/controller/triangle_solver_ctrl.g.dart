// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'triangle_solver_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TriangleSolverCtrl)
const triangleSolverCtrlProvider = TriangleSolverCtrlProvider._();

final class TriangleSolverCtrlProvider
    extends $NotifierProvider<TriangleSolverCtrl, TriangleState> {
  const TriangleSolverCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'triangleSolverCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$triangleSolverCtrlHash();

  @$internal
  @override
  TriangleSolverCtrl create() => TriangleSolverCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TriangleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TriangleState>(value),
    );
  }
}

String _$triangleSolverCtrlHash() =>
    r'0cc6b69f7494d794cc8d115b5a85cc485a96bece';

abstract class _$TriangleSolverCtrl extends $Notifier<TriangleState> {
  TriangleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TriangleState, TriangleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TriangleState, TriangleState>,
              TriangleState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
