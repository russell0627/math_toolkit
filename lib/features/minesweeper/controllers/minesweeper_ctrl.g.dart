// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minesweeper_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MinesweeperCtrl)
const minesweeperCtrlProvider = MinesweeperCtrlProvider._();

final class MinesweeperCtrlProvider
    extends $NotifierProvider<MinesweeperCtrl, MinesweeperBoard> {
  const MinesweeperCtrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'minesweeperCtrlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$minesweeperCtrlHash();

  @$internal
  @override
  MinesweeperCtrl create() => MinesweeperCtrl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MinesweeperBoard value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MinesweeperBoard>(value),
    );
  }
}

String _$minesweeperCtrlHash() => r'0740908dde4bef338a6543745d398ea5860e824b';

abstract class _$MinesweeperCtrl extends $Notifier<MinesweeperBoard> {
  MinesweeperBoard build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MinesweeperBoard, MinesweeperBoard>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MinesweeperBoard, MinesweeperBoard>,
              MinesweeperBoard,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(MinesweeperControlMode)
const minesweeperControlModeProvider = MinesweeperControlModeProvider._();

final class MinesweeperControlModeProvider
    extends $NotifierProvider<MinesweeperControlMode, MinesweeperMode> {
  const MinesweeperControlModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'minesweeperControlModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$minesweeperControlModeHash();

  @$internal
  @override
  MinesweeperControlMode create() => MinesweeperControlMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MinesweeperMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MinesweeperMode>(value),
    );
  }
}

String _$minesweeperControlModeHash() =>
    r'dc1f602dbcaf1fa1a69a4a8b5582bbfbf1b885bc';

abstract class _$MinesweeperControlMode extends $Notifier<MinesweeperMode> {
  MinesweeperMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MinesweeperMode, MinesweeperMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MinesweeperMode, MinesweeperMode>,
              MinesweeperMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
