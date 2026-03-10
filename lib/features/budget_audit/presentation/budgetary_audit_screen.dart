import 'dart:math' as math;

import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/budgetary_audit_ctrl.dart';

class BudgetaryAuditScreen extends ConsumerStatefulWidget {
  const BudgetaryAuditScreen({super.key});

  @override
  ConsumerState<BudgetaryAuditScreen> createState() => _BudgetaryAuditScreenState();
}

class _BudgetaryAuditScreenState extends ConsumerState<BudgetaryAuditScreen> {
  final TextEditingController _inputController = TextEditingController();

  void _addEntry() {
    final value = double.tryParse(_inputController.text);
    if (value != null) {
      ref.read(budgetaryAuditCtrlProvider.notifier).addEntry(value);
      _inputController.clear();
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetaryAuditCtrlProvider);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AUDIT-UNIT: SN-BUREAU-0003",
          style: GoogleFonts.cutiveMono(
            color: Colors.white24,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "FISCAL AUDIT IN PROGRESS",
              style: GoogleFonts.ebGaramond(
                textStyle: styles.labelSmall.copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Input Area
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: GoogleFonts.cutiveMono(color: Colors.greenAccent),
                    decoration: InputDecoration(
                      labelText: "ENTER DATA POINT",
                      labelStyle: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.3),
                      border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent, width: 1),
                      ),
                    ),
                    onSubmitted: (_) => _addEntry(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _addEntry,
                  icon: const Icon(Icons.add, color: Colors.black),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Chart Area
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF050F05),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2), width: 2),
              ),
              child: state.entries.isEmpty
                  ? Center(
                      child: Text(
                        "WAITING FOR INPUT...",
                        style: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 10),
                      ),
                    )
                  : CustomPaint(
                      painter: LofiAuditChartPainter(state.entries),
                    ),
            ),
            const SizedBox(height: 24),
            // Statistics Area
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AUDIT REPORT SUMMARY",
                      style: GoogleFonts.cutiveMono(color: Colors.amberAccent.withValues(alpha: 0.5), fontSize: 10),
                    ),
                    const Divider(color: Colors.white10),
                    _StatRow("MEAN avg", state.mean?.toStringAsFixed(2) ?? "N/A"),
                    _StatRow("MEDIAN mid", state.median?.toStringAsFixed(2) ?? "N/A"),
                    _StatRow("STD DEV dev", state.stdDev?.toStringAsFixed(2) ?? "N/A"),
                    _StatRow("MAX peak", state.max?.toStringAsFixed(2) ?? "N/A"),
                    _StatRow("MIN floor", state.min?.toStringAsFixed(2) ?? "N/A"),
                    _StatRow("COUNT qty", state.entries.length.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: 11),
          ),
          Text(
            value,
            style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class LofiAuditChartPainter extends CustomPainter {
  final List<double> entries;

  LofiAuditChartPainter(this.entries);

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final maxVal = entries.reduce(math.max);
    final minVal = entries.reduce(math.min);
    final range = (maxVal - minVal).abs() < 0.0001 ? maxVal : maxVal - minVal;

    final barWidth = (size.width / entries.length) * 0.8;
    final spacing = (size.width / entries.length) * 0.2;

    for (var i = 0; i < entries.length; i++) {
      // Normalize height
      final normalized = range == 0 ? 0.5 : (entries[i] / maxVal);
      final barHeight = size.height * normalized;

      final rect = Rect.fromLTWH(
        i * (barWidth + spacing),
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      // Draw bar with slight transparency
      canvas.drawRect(rect, paint..color = Colors.greenAccent.withValues(alpha: 0.6));

      // Draw top edge highlight
      canvas.drawLine(
        Offset(rect.left, rect.top),
        Offset(rect.right, rect.top),
        paint
          ..color = Colors.greenAccent
          ..strokeWidth = 1,
      );
    }

    // Draw baseline
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()
        ..color = Colors.white10
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant LofiAuditChartPainter oldDelegate) {
    return oldDelegate.entries != entries;
  }
}
