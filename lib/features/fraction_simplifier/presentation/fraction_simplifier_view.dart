import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/fraction_simplifier_ctrl.dart';

class FractionSimplifierView extends ConsumerWidget {
  final bool isCompact;
  const FractionSimplifierView({super.key, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fractionSimplifierCtrlProvider);
    final ctrl = ref.read(fractionSimplifierCtrlProvider.notifier);
    final styles = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isCompact ? 16 : 28),
      child: Column(
        children: [
          SizedBox(height: isCompact ? 10 : 20),
          Text(
            "FRACTIONAL REDUCTION AUTHORIZED",
            style: GoogleFonts.ebGaramond(
              textStyle: styles.labelSmall?.copyWith(
                color: Colors.white38,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 8 : 10,
              ),
            ),
          ),
          SizedBox(height: isCompact ? 20 : 40),
          _buildFractionInput(
            "NUMERATOR",
            (val) => ctrl.setNumerator(val),
            styles,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isCompact ? 10 : 20),
            child: Divider(color: Colors.white10, thickness: isCompact ? 1 : 2),
          ),
          _buildFractionInput(
            "DENOMINATOR",
            (val) => ctrl.setDenominator(val),
            styles,
          ),
          SizedBox(height: isCompact ? 20 : 40),
          ElevatedButton(
            onPressed: ctrl.simplify,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, isCompact ? 40 : 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(
              isCompact ? "SIMPLIFY" : "EXECUTE SIMPLIFICATION",
              style: GoogleFonts.ebGaramond(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 2,
                  fontSize: isCompact ? 10 : 12,
                ),
              ),
            ),
          ),
          SizedBox(height: isCompact ? 20 : 40),
          if (state.isSimplified) _buildResultDisplay(state, styles),
          if (!isCompact) ...[
            const Spacer(),
            Text(
              "REDUCTION PROTOCOL v2.4",
              style: styles.labelSmall?.copyWith(
                color: Colors.white24,
                fontSize: 10,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildFractionInput(String label, Function(String) onChanged, TextTheme styles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: isCompact ? 8 : 10),
        ),
        SizedBox(height: isCompact ? 4 : 8),
        TextField(
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: isCompact ? 18 : 24),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 1)),
          ),
        ),
      ],
    );
  }

  Widget _buildResultDisplay(FractionState state, TextTheme styles) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 12 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF050F05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        children: [
          Text(
            "REDUCED FORM",
            style: GoogleFonts.cutiveMono(color: Colors.greenAccent.withValues(alpha: 0.5), fontSize: isCompact ? 8 : 10),
          ),
          SizedBox(height: isCompact ? 8 : 12),
          FittedBox(
            child: Text(
              "${state.simplifiedNumerator} / ${state.simplifiedDenominator}",
              style: GoogleFonts.cutiveMono(
                color: Colors.greenAccent,
                fontSize: isCompact ? 24 : 32,
                fontWeight: FontWeight.bold,
                shadows: [const Shadow(color: Colors.greenAccent, blurRadius: 10)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}