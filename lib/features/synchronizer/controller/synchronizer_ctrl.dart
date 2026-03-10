import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synchronizer_ctrl.g.dart';

enum SyncType { length, mass, time }

@riverpod
class SynchronizerCtrl extends _$SynchronizerCtrl {
  @override
  SyncState build() {
    return const SyncState();
  }

  void setInput(String value) {
    state = state.copyWith(inputValue: double.tryParse(value) ?? 0);
    _convert();
  }

  void setType(SyncType type) {
    state = state.copyWith(type: type);
    _convert();
  }

  void _convert() {
    double result = 0;
    String unit = "";

    switch (state.type) {
      case SyncType.length:
        // Meters to Feet
        result = state.inputValue * 3.28084;
        unit = "FT";
      case SyncType.mass:
        // KG to LBS
        result = state.inputValue * 2.20462;
        unit = "LBS";
      case SyncType.time:
        // Hours to Bureau-Cycles (Custom 10-hour metric day)
        result = state.inputValue * 0.41666;
        unit = "CYCLES";
    }

    state = state.copyWith(resultValue: result, unit: unit);
  }
}

class SyncState {
  final double inputValue;
  final double resultValue;
  final String unit;
  final SyncType type;

  const SyncState({
    this.inputValue = 0,
    this.resultValue = 0,
    this.unit = "FT",
    this.type = SyncType.length,
  });

  SyncState copyWith({
    double? inputValue,
    double? resultValue,
    String? unit,
    SyncType? type,
  }) {
    return SyncState(
      inputValue: inputValue ?? this.inputValue,
      resultValue: resultValue ?? this.resultValue,
      unit: unit ?? this.unit,
      type: type ?? this.type,
    );
  }
}
