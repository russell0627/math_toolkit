import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/workbench_model.dart';

part 'workbench_ctrl.g.dart';

@riverpod
class WorkbenchCtrl extends _$WorkbenchCtrl {
  @override
  WorkbenchState build() {
    return const WorkbenchState();
  }

  void selectMain(MainModule module) {
    state = state.copyWith(activeMain: module);
  }

  void selectUtility(UtilityModule module) {
    state = state.copyWith(activeUtility: module);
  }

  void selectSubUtility(SubUtilityModule module) {
    state = state.copyWith(activeSubUtility: module);
  }

  void toggleSidebar() {
    state = state.copyWith(isSidebarExpanded: !state.isSidebarExpanded);
  }
}
