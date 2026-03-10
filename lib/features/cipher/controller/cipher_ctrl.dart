import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cipher_ctrl.g.dart';

enum CipherType { caesar, vigenere }

@riverpod
class CipherCtrl extends _$CipherCtrl {
  @override
  CipherState build() {
    return const CipherState();
  }

  void setInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  void setKey(String key) {
    state = state.copyWith(key: key);
  }

  void setType(CipherType type) {
    state = state.copyWith(type: type);
  }

  void execute(bool encrypt) {
    final result = encrypt ? _encrypt() : _decrypt();
    state = state.copyWith(resultText: result, isResultVisible: true);
  }

  String _encrypt() {
    if (state.type == CipherType.caesar) {
      final shift = int.tryParse(state.key) ?? 0;
      return _caesar(state.inputText, shift);
    } else {
      return _vigenere(state.inputText, state.key, true);
    }
  }

  String _decrypt() {
    if (state.type == CipherType.caesar) {
      final shift = int.tryParse(state.key) ?? 0;
      return _caesar(state.inputText, -shift);
    } else {
      return _vigenere(state.inputText, state.key, false);
    }
  }

  String _caesar(String text, int shift) {
    final sb = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      var charCode = text.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        // A-Z
        sb.writeCharCode((charCode - 65 + shift) % 26 + 65);
      } else if (charCode >= 97 && charCode <= 122) {
        // a-z
        sb.writeCharCode((charCode - 97 + shift) % 26 + 97);
      } else {
        sb.writeCharCode(charCode);
      }
    }
    return sb.toString();
  }

  String _vigenere(String text, String key, bool encrypt) {
    if (key.isEmpty) return text;
    final sb = StringBuffer();
    final keyUpper = key.toUpperCase();
    var keyIndex = 0;

    for (var i = 0; i < text.length; i++) {
      var charCode = text.codeUnitAt(i);
      if ((charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122)) {
        final isUpper = charCode >= 65 && charCode <= 90;
        final base = isUpper ? 65 : 97;
        final keyShift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
        final shift = encrypt ? keyShift : -keyShift;

        sb.writeCharCode((charCode - base + shift + 26) % 26 + base);
        keyIndex++;
      } else {
        sb.writeCharCode(charCode);
      }
    }
    return sb.toString();
  }
}

class CipherState {
  final String inputText;
  final String key;
  final String resultText;
  final CipherType type;
  final bool isResultVisible;

  const CipherState({
    this.inputText = "",
    this.key = "",
    this.resultText = "",
    this.type = CipherType.caesar,
    this.isResultVisible = false,
  });

  CipherState copyWith({
    String? inputText,
    String? key,
    String? resultText,
    CipherType? type,
    bool? isResultVisible,
  }) {
    return CipherState(
      inputText: inputText ?? this.inputText,
      key: key ?? this.key,
      resultText: resultText ?? this.resultText,
      type: type ?? this.type,
      isResultVisible: isResultVisible ?? this.isResultVisible,
    );
  }
}
