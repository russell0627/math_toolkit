import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorDisplay extends StatelessWidget {
  final String display;
  final String? expression;

  const CalculatorDisplay({
    super.key,
    required this.display,
    this.expression,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF050F05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.greenAccent.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                expression?.isEmpty ?? true ? 'SYSTEM IDLE' : expression!,
                style: GoogleFonts.cutiveMono(
                  color: Colors.greenAccent.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                (display == '0' || display.isEmpty) && (expression?.isEmpty ?? true) ? 'READY' : display,
                style: GoogleFonts.cutiveMono(
                  color: Colors.greenAccent,
                  fontSize: 42, // Increased for emphasis
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      color: Colors.greenAccent,
                      blurRadius: 10,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Positioned.fill(child: _CRTOverlay()),
        ],
      ),
    );
  }
}

class _CRTOverlay extends StatelessWidget {
  const _CRTOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              for (var i = 0; i < 40; i++) ...[
                Colors.black.withValues(alpha: i % 2 == 0 ? 0.15 : 0.0),
                Colors.black.withValues(alpha: i % 2 == 0 ? 0.15 : 0.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
