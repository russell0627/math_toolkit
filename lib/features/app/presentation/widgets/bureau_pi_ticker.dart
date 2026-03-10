import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BureauPiTicker extends StatefulWidget {
  final ValueChanged<int>? onDigitCountChanged;
  const BureauPiTicker({super.key, this.onDigitCountChanged});

  @override
  State<BureauPiTicker> createState() => _BureauPiTickerState();
}

class _BureauPiTickerState extends State<BureauPiTicker> {
  // Spigot State Variables
  BigInt _q = BigInt.one;
  BigInt _r = BigInt.zero;
  BigInt _t = BigInt.one;
  BigInt _k = BigInt.one;
  BigInt _n = BigInt.from(3);
  BigInt _l = BigInt.from(3);

  final List<String> _digits = [];

  // Digit metrics for adaptive calculation
  static const double _fontSize = 32;
  static const double _digitSpacing = 8;
  // Approximating width for a monospaced character
  static const double _estimatedDigitWidth = _fontSize * 0.7;

  @override
  void initState() {
    super.initState();
    // Warm up with first few digits
    _calculateTarget(120);
  }

  void _calculateTarget(int targetIndex) {
    while (_digits.length <= targetIndex) {
      if (BigInt.from(4) * _q + _r - _t < _n * _t) {
        String digit = _n.toString();
        if (_digits.isEmpty) {
          digit = "$digit."; // Inject decimal point after '3'
        }
        _digits.add(digit);

        BigInt nr = BigInt.from(10) * (_r - _n * _t);
        _n = BigInt.from(10) * (BigInt.from(3) * _q + _r) ~/ _t - BigInt.from(10) * _n;
        _q = BigInt.from(10) * _q;
        _r = nr;
      } else {
        BigInt nr = (BigInt.two * _q + _r) * _l;
        BigInt nn = (_q * (BigInt.from(7) * _k + BigInt.two) + _r * _l) ~/ (_t * _l);
        _q = _q * _k;
        _t = _t * _l;
        _l = _l + BigInt.two;
        _k = _k + BigInt.one;
        _n = nn;
        _r = nr;
      }
    }
    Future.microtask(() {
      if (mounted) widget.onDigitCountChanged?.call(_digits.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate digits per row based on available width minus some padding
        final availableWidth = constraints.maxWidth - 32; // 16px padding on each side
        final digitsPerRow = (availableWidth / (_estimatedDigitWidth + _digitSpacing)).floor().clamp(1, 20);

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemBuilder: (context, rowIndex) {
            final startIndex = rowIndex * digitsPerRow;
            final endIndex = startIndex + digitsPerRow;

            // Ensure we have enough digits calculated for this row
            if (endIndex > _digits.length) {
              _calculateTarget(endIndex + (digitsPerRow * 10)); // Calculate a bit ahead
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(digitsPerRow, (i) {
                  final d = _digits[startIndex + i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      d.toString(),
                      style: GoogleFonts.cutiveMono(
                        color: Colors.amberAccent.withValues(alpha: 0.8),
                        fontSize: _fontSize,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.amberAccent.withValues(alpha: 0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        );
      },
    );
  }
}
