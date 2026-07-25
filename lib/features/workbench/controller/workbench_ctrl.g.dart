// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workbench_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkbenchCtrl)
const workbenchCtrlProvider = WorkbenchCtrlProvider._();

final class WorkbenchCtrlProvider
    extends $NotifierProvider<WorkbenchCtrl, WorkbenchState> {
  const WorkbenchCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workbenchCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workbenchCtrlHash();

  @$internal
  @override
  WorkbenchCtrl create() => WorkbenchCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkbenchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkbenchState>(value),
    );
  }
}

String _$workbenchCtrlHash() => r'3db0c3a353a8e1351437f895b7272815e4af10d8';

abstract class _$WorkbenchCtrl extends $Notifier<WorkbenchState> {
  WorkbenchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WorkbenchState, WorkbenchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WorkbenchState, WorkbenchState>,
              WorkbenchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
