import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum StampType { authenticated, critical, sanction }

class BureauStamp extends StatelessWidget {
  final StampType type;
  final String? label;
  final VoidCallback? onComplete;

  const BureauStamp({
    super.key,
    this.type = StampType.authenticated,
    this.label,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final String text = label ?? _getDefaultText();
    final Color color = _getColor();

    return IgnorePointer(
      child: Center(
        child:
            Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: color.withOpacity(0.8), width: 3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.cutiveMono(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(4, 4),
                  end: const Offset(1, 1),
                  duration: 200.ms,
                  curve: Curves.easeInCirc,
                )
                .shake(hz: 10, offset: const Offset(2, 2), duration: 100.ms)
                .then()
                .fadeOut(delay: 1500.ms, duration: 500.ms),
      ),
    );
  }

  String _getDefaultText() {
    switch (type) {
      case StampType.authenticated:
        return "AUTHENTICATED";
      case StampType.critical:
        return "CRITICAL";
      case StampType.sanction:
        return "SANCTIONED";
    }
  }

  Color _getColor() {
    switch (type) {
      case StampType.authenticated:
        return Colors.greenAccent;
      case StampType.critical:
        return Colors.redAccent;
      case StampType.sanction:
        return Colors.amberAccent;
    }
  }
}
