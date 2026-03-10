import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/rotation_model.dart';

part 'rotation_ctrl.g.dart';

@riverpod
class RotationCtrl extends _$RotationCtrl {
  @override
  RotationState build() {
    return const RotationState();
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
    state = const RotationState();
  }
}
