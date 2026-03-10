import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/reflection_model.dart';

part 'reflection_ctrl.g.dart';

@riverpod
class ReflectionCtrl extends _$ReflectionCtrl {
  @override
  ReflectionState build() {
    return const ReflectionState();
  }

  void updateX(String value) {
    final val = double.tryParse(value);
    state = state.copyWith(x: val);
  }

  void updateY(String value) {
    final val = double.tryParse(value);
    state = state.copyWith(y: val);
  }

  void reset() {
    state = const ReflectionState();
  }
}
