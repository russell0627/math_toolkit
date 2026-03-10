import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'widgets/bureau_pi_ticker.dart';
import 'widgets/bureau_stamp.dart';

class PiStreamScreen extends StatefulWidget {
  const PiStreamScreen({super.key});

  @override
  State<PiStreamScreen> createState() => _PiStreamScreenState();
}

class _PiStreamScreenState extends State<PiStreamScreen> {
  int _calculatedDigits = 0;
  final Set<int> _achievedMilestones = {};
  int? _currentMilestoneTrigger;
  bool _showStamp = false;

  final List<int> _milestones = [100, 314, 500, 1000, 3141, 5000, 10000];

  void _checkMilestones(int count) {
    for (final m in _milestones) {
      if (count >= m && !_achievedMilestones.contains(m)) {
        setState(() {
          _achievedMilestones.add(m);
          _currentMilestoneTrigger = m;
          _showStamp = true;
        });
        break; // Trigger one at a time if they scroll fast
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background "glow" effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Colors.amberAccent.withOpacity(0.05),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
          // Infinite Ticker - Wrapped in a constrained Viewport area
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 120),
            child: Center(
              child: BureauPiTicker(
                onDigitCountChanged: (count) {
                  setState(() => _calculatedDigits = count);
                  _checkMilestones(count);
                },
              ),
            ),
          ),
          // Milestone Stamp
          if (_showStamp)
            BureauStamp(
              type: StampType.sanction,
              label: "PRECISION: $_currentMilestoneTrigger",
              onComplete: () => setState(() => _showStamp = false),
            ),
          // HUD Shroud - Top (Protects Instrumentation)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // HUD Shroud - Bottom (Protects Controls)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Scanline Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: List.generate(100, (i) => i % 2 == 0 ? Colors.black.withOpacity(0.05) : Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
          // Perspective Overlay (Faux curved edges)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // HUD Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "OBSERVATIONAL BAY: PI-STREAM",
                    style: GoogleFonts.cutiveMono(
                      color: Colors.white24,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ENGINE STATUS: ACTIVE [SPIGOT-UNBOUNDED]",
                    style: GoogleFonts.cutiveMono(
                      color: Colors.greenAccent.withValues(alpha: 0.5),
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    "PRECISION AUDIT: $_calculatedDigits DIGITS RESOLVED",
                    style: GoogleFonts.cutiveMono(
                      color: Colors.amberAccent.withValues(alpha: 0.3),
                      fontSize: 8,
                    ),
                  ),
                  if (_achievedMilestones.isNotEmpty)
                    Text(
                      "HIGHEST MILESTONE: ${_achievedMilestones.last} [SANCTIONED]",
                      style: GoogleFonts.cutiveMono(
                        color: Colors.redAccent.withValues(alpha: 0.4),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.amberAccent.withOpacity(0.2)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "TERMINATE CONNECTION",
                        style: GoogleFonts.cutiveMono(
                          color: Colors.amberAccent,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
