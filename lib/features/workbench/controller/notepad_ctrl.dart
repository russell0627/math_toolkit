import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notepad_ctrl.g.dart';

@riverpod
class NotepadCtrl extends _$NotepadCtrl {
  @override
  String build() {
    return "";
  }

  void updateContent(String value) {
    state = value;
  }

  void clear() {
    state = "";
  }
}
