import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BureauBalanceScale extends StatelessWidget {
  final double leftWeight;
  final double rightWeight;

  const BureauBalanceScale({
    super.key,
    required this.leftWeight,
    required this.rightWeight,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate tilt angle (-pi/12 to pi/12)
    final double total = leftWeight + rightWeight;
    double tilt = 0;
    if (total > 0) {
      tilt = (rightWeight - leftWeight) / total * (math.pi / 8);
    }

    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Base
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Vertical Support
          Positioned(
            bottom: 4,
            child: Container(
              width: 2,
              height: 30,
              color: Colors.white10,
            ),
          ),
          // Pivot & Beam
          Positioned(
            bottom: 30,
            child: Transform.rotate(
              angle: tilt,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Beam
                  Container(
                    width: 140,
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white24,
                          Colors.white24,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Left Pan Support
                  Positioned(
                    left: 0,
                    child: _buildPan(leftWeight, true),
                  ),
                  // Right Pan Support
                  Positioned(
                    right: 0,
                    child: _buildPan(rightWeight, false),
                  ),
                ],
              ),
            ),
          ),
          // Complexity Indicator Text
          Positioned(
            top: 0,
            child: Text(
              "COMPLEXITY BALANCE",
              style: GoogleFonts.cutiveMono(
                color: Colors.white10,
                fontSize: 8,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPan(double weight, bool isLeft) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 1,
          height: 15,
          color: Colors.white10,
        ),
        Container(
          width: 30,
          height: 2,
          color: Colors.amberAccent.withValues(alpha: 0.1 + (weight * 0.1).clamp(0.0, 0.4)),
        ),
      ],
    );
  }
}
