import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../app/services/persistence/persistence_service.dart';

part 'settings_ctrl.g.dart';

class SettingsState {
  final bool isRationalMode;
  final bool isAutoApplyMode;
  final bool isAutoSolveEnabled;
  final bool isRadicalMode;
  final bool isDrawerOnRight;
  final bool isSplitEntryMode;
  final bool useBureauNaming;

  const SettingsState({
    this.isRationalMode = false,
    this.isAutoApplyMode = false,
    this.isAutoSolveEnabled = false,
    this.isRadicalMode = true,
    this.isDrawerOnRight = false,
    this.isSplitEntryMode = false,
    this.useBureauNaming = false,
  });

  SettingsState copyWith({
    bool? isRationalMode,
    bool? isAutoApplyMode,
    bool? isAutoSolveEnabled,
    bool? isRadicalMode,
    bool? isDrawerOnRight,
    bool? isSplitEntryMode,
    bool? useBureauNaming,
  }) {
    return SettingsState(
      isRationalMode: isRationalMode ?? this.isRationalMode,
      isAutoApplyMode: isAutoApplyMode ?? this.isAutoApplyMode,
      isAutoSolveEnabled: isAutoSolveEnabled ?? this.isAutoSolveEnabled,
      isRadicalMode: isRadicalMode ?? this.isRadicalMode,
      isDrawerOnRight: isDrawerOnRight ?? this.isDrawerOnRight,
      isSplitEntryMode: isSplitEntryMode ?? this.isSplitEntryMode,
      useBureauNaming: useBureauNaming ?? this.useBureauNaming,
    );
  }
}

@riverpod
class SettingsCtrl extends _$SettingsCtrl {
  @override
  SettingsState build() {
    final persistence = ref.watch(persistenceServiceProvider.notifier);

    return SettingsState(
      isRationalMode: persistence.getBool('isRationalMode'),
      isAutoApplyMode: persistence.getBool('isAutoApplyMode'),
      isAutoSolveEnabled: persistence.getBool('isAutoSolveEnabled'),
      isRadicalMode: persistence.getBool('isRadicalMode', defaultValue: true),
      isDrawerOnRight: persistence.getBool('isDrawerOnRight', defaultValue: false),
      isSplitEntryMode: persistence.getBool('isSplitEntryMode', defaultValue: false),
      useBureauNaming: persistence.getBool('useBureauNaming', defaultValue: false),
    );
  }

  void toggleRationalMode() {
    final newValue = !state.isRationalMode;
    state = state.copyWith(isRationalMode: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isRationalMode', newValue);
  }

  void toggleAutoApplyMode() {
    final newValue = !state.isAutoApplyMode;
    state = state.copyWith(isAutoApplyMode: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isAutoApplyMode', newValue);
  }

  void toggleAutoSolve() {
    final newValue = !state.isAutoSolveEnabled;
    state = state.copyWith(isAutoSolveEnabled: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isAutoSolveEnabled', newValue);
  }

  void toggleRadicalMode() {
    final newValue = !state.isRadicalMode;
    state = state.copyWith(isRadicalMode: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isRadicalMode', newValue);
  }

  void toggleDrawerSide() {
    final newValue = !state.isDrawerOnRight;
    state = state.copyWith(isDrawerOnRight: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isDrawerOnRight', newValue);
  }

  void toggleSplitEntry() {
    final newValue = !state.isSplitEntryMode;
    state = state.copyWith(isSplitEntryMode: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('isSplitEntryMode', newValue);
  }

  void toggleBureauNaming() {
    final newValue = !state.useBureauNaming;
    state = state.copyWith(useBureauNaming: newValue);
    ref.read(persistenceServiceProvider.notifier).setBool('useBureauNaming', newValue);
  }
}
