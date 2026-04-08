// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transformation_sequence_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransformationSequenceCtrl)
const transformationSequenceCtrlProvider =
    TransformationSequenceCtrlProvider._();

final class TransformationSequenceCtrlProvider
    extends
        $NotifierProvider<
          TransformationSequenceCtrl,
          TransformationSequenceState
        > {
  const TransformationSequenceCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transformationSequenceCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transformationSequenceCtrlHash();

  @$internal
  @override
  TransformationSequenceCtrl create() => TransformationSequenceCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransformationSequenceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransformationSequenceState>(value),
    );
  }
}

String _$transformationSequenceCtrlHash() =>
    r'9df1096c1818bee9097a7c46f87ab7dbb8d6e167';

abstract class _$TransformationSequenceCtrl
    extends $Notifier<TransformationSequenceState> {
  TransformationSequenceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<TransformationSequenceState, TransformationSequenceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                TransformationSequenceState,
                TransformationSequenceState
              >,
              TransformationSequenceState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
