// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ReflectionCtrl)
const reflectionCtrlProvider = ReflectionCtrlProvider._();

final class ReflectionCtrlProvider
    extends $NotifierProvider<ReflectionCtrl, ReflectionState> {
  const ReflectionCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reflectionCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reflectionCtrlHash();

  @$internal
  @override
  ReflectionCtrl create() => ReflectionCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReflectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReflectionState>(value),
    );
  }
}

String _$reflectionCtrlHash() => r'a6a40f94779b81c153a172d226c866959a03ebd6';

abstract class _$ReflectionCtrl extends $Notifier<ReflectionState> {
  ReflectionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ReflectionState, ReflectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReflectionState, ReflectionState>,
              ReflectionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
