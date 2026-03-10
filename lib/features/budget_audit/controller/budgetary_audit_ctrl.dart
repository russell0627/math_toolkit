import 'dart:math' as math;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budgetary_audit_ctrl.g.dart';

@riverpod
class BudgetaryAuditCtrl extends _$BudgetaryAuditCtrl {
  @override
  AuditState build() {
    return const AuditState();
  }

  void addEntry(double value) {
    final newList = [...state.entries, value];
    _updateStats(newList);
  }

  void removeEntry(int index) {
    if (index < 0 || index >= state.entries.length) return;
    final newList = List<double>.from(state.entries)..removeAt(index);
    _updateStats(newList);
  }

  void clear() {
    state = const AuditState();
  }

  void _updateStats(List<double> entries) {
    if (entries.isEmpty) {
      state = const AuditState();
      return;
    }

    // Sort for median
    final sorted = List<double>.from(entries)..sort();

    // Mean
    final mean = entries.reduce((a, b) => a + b) / entries.length;

    // Median
    double median;
    if (sorted.length % 2 == 0) {
      median = (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) / 2;
    } else {
      median = sorted[sorted.length ~/ 2];
    }

    // Standard Deviation
    final variance = entries.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / entries.length;
    final stdDev = math.sqrt(variance);

    state = state.copyWith(
      entries: entries,
      mean: mean,
      median: median,
      stdDev: stdDev,
      max: sorted.last,
      min: sorted.first,
    );
  }
}

class AuditState {
  final List<double> entries;
  final double? mean;
  final double? median;
  final double? stdDev;
  final double? max;
  final double? min;

  const AuditState({
    this.entries = const [],
    this.mean,
    this.median,
    this.stdDev,
    this.max,
    this.min,
  });

  AuditState copyWith({
    List<double>? entries,
    double? mean,
    double? median,
    double? stdDev,
    double? max,
    double? min,
  }) {
    return AuditState(
      entries: entries ?? this.entries,
      mean: mean ?? this.mean,
      median: median ?? this.median,
      stdDev: stdDev ?? this.stdDev,
      max: max ?? this.max,
      min: min ?? this.min,
    );
  }
}
