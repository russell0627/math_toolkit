import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../radical_simplifier/controller/radical_ctrl.dart';
import '../model/grid_model.dart';

part 'grid_ctrl.g.dart';

@riverpod
class GridPythagoreanCtrl extends _$GridPythagoreanCtrl {
  @override
  GridPythagoreanState build() {
    return const GridPythagoreanState();
  }

  void updateX1(String value) {
    state = state.copyWith(x1: double.tryParse(value));
    _syncRadical();
  }

  void updateY1(String value) {
    state = state.copyWith(y1: double.tryParse(value));
    _syncRadical();
  }

  void updateX2(String value) {
    state = state.copyWith(x2: double.tryParse(value));
    _syncRadical();
  }

  void updateY2(String value) {
    state = state.copyWith(y2: double.tryParse(value));
    _syncRadical();
  }

  void _syncRadical() {
    if (state.isComplete) {
      final double rVal =
          (state.x2! - state.x1!) * (state.x2! - state.x1!) + (state.y2! - state.y1!) * (state.y2! - state.y1!);
      final int radicand = rVal.round();
      if (radicand > 0) {
        ref.read(radicalCtrlProvider.notifier).simplify(radicand.toString());
      }
    }
  }

  void purge() {
    state = const GridPythagoreanState();
  }
}
