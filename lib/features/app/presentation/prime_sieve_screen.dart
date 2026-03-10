import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/dossier_service.dart';
import 'widgets/bureau_prime_sieve.dart';
import 'widgets/tactical_console.dart';

class PrimeSieveScreen extends StatefulWidget {
  const PrimeSieveScreen({super.key});

  @override
  State<PrimeSieveScreen> createState() => _PrimeSieveScreenState();
}

class _PrimeSieveScreenState extends State<PrimeSieveScreen> {
  BigInt _highestPrime = BigInt.zero;
  int _perfectCount = 0;
  int _piFragmentCount = 0;
  double _primeDensity = 0.0;

  bool _isDeNoiseEnabled = false;
  bool _isXRayEnabled = false;
  bool _isTelemetryEnabled = false;
  bool _isHeatMapEnabled = false;
  SpectrumMode _spectrumMode = SpectrumMode.standard;
  int _scanSpeedMs = 150;
  double _stabilityFactor = 1.0;
  final DossierService _dossier = DossierService();
  final GlobalKey<BureauPrimeSieveState> _sieveKey = GlobalKey<BureauPrimeSieveState>();
  final TextEditingController _gotoController = TextEditingController();
  final TextEditingController _patternController = TextEditingController();
  String? _stencilPattern;
  bool _isConsoleExpanded = false;
  bool _isHyperScanEnabled = false;
  bool _isAutoScrollEnabled = false;
  int _cachedScanSpeed = 150;
  bool _isScientificNotationEnabled = true;

  @override
  void initState() {
    super.initState();
    _dossier.init();
  }

  @override
  void dispose() {
    _gotoController.dispose();
    _patternController.dispose();
    super.dispose();
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
                    Colors.amberAccent.withValues(alpha: 0.05),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Prime Sieve Grid
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 120),
            child: BureauPrimeSieve(
              key: _sieveKey,
              onHighestPrimeChanged: (val) => setState(() => _highestPrime = val),
              onDensityChanged: (val) => setState(() => _primeDensity = val),
              onPerfectCountChanged: (val) => setState(() => _perfectCount = val),
              onPiFragmentDetected: (val) => setState(() => _piFragmentCount = val),
              isDeNoiseEnabled: _isDeNoiseEnabled,
              isXRayEnabled: _isXRayEnabled,
              isTelemetryEnabled: _isTelemetryEnabled,
              isHeatMapEnabled: _isHeatMapEnabled,
              scanSpeedMs: _scanSpeedMs,
              stabilityFactor: _stabilityFactor,
              spectrumMode: _spectrumMode,
              pattern: _stencilPattern,
              dossier: _dossier,
              isAutoScrollEnabled: _isAutoScrollEnabled,
              isScientificNotationEnabled: _isScientificNotationEnabled,
            ),
          ),

          // HUD Shroud - Top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 140,
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

          // HUD Shroud - Bottom
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
                    colors: List.generate(
                      100,
                      (i) => i % 2 == 0 ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // HUD Controls
          SafeArea(
            child: Column(
              children: [
                // Minimal Header Bar
                _buildHeaderBar(),

                // Collapsible Console
                TacticalConsole(
                  isExpanded: _isConsoleExpanded,
                  onToggle: () => setState(() => _isConsoleExpanded = !_isConsoleExpanded),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildControlToggle(
                            label: "DOSSIER",
                            value: false,
                            onChanged: (val) => _showDossier(),
                            activeColor: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: TextField(
                                controller: _gotoController,
                                style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 10),
                                decoration: InputDecoration(
                                  hintText: "GOTO INDEX",
                                  hintStyle: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 10),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.arrow_forward, size: 14, color: Colors.amberAccent),
                                    onPressed: () async {
                                      final raw = _gotoController.text;
                                      if (raw.isEmpty) return;

                                      SmartDialog.showLoading(msg: "CALCULATING TARGET COORDINATE...");
                                      try {
                                        // Tactical Induction: Offload to background to prevent main-thread thermal lockup
                                        final idx = await _parseBigIntInduction(raw);
                                        SmartDialog.dismiss();

                                        if (idx != null) {
                                          _sieveKey.currentState?.jumpToIndex(idx);
                                          _gotoController.clear();
                                        } else {
                                          SmartDialog.showToast("INPUT ERROR: INDUCTION FAILURE");
                                        }
                                      } catch (e) {
                                        SmartDialog.dismiss();
                                        SmartDialog.showToast("CRITICAL ERROR: CALCULATION ABORTED");
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.pinkAccent.withValues(alpha: 0.05),
                        ),
                        child: TextField(
                          controller: _patternController,
                          style: GoogleFonts.cutiveMono(color: Colors.pinkAccent, fontSize: 10),
                          onChanged: (val) {
                            setState(() => _stencilPattern = val.isEmpty ? null : val);
                          },
                          decoration: InputDecoration(
                            hintText: "STENCIL (e.g. *777*)",
                            hintStyle: GoogleFonts.cutiveMono(
                              color: Colors.pinkAccent.withValues(alpha: 0.2),
                              fontSize: 10,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.psychology_alt, size: 14, color: Colors.pinkAccent),
                            suffixIcon: _stencilPattern != null
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 14, color: Colors.pinkAccent),
                                    onPressed: () {
                                      _patternController.clear();
                                      setState(() => _stencilPattern = null);
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildControlToggle(
                            label: "HYPER-SCAN [!] ",
                            value: _isHyperScanEnabled,
                            onChanged: (val) {
                              setState(() {
                                _isHyperScanEnabled = val;
                                if (val) {
                                  _cachedScanSpeed = _scanSpeedMs;
                                  _scanSpeedMs = 1;
                                } else {
                                  _scanSpeedMs = _cachedScanSpeed;
                                }
                              });
                            },
                            activeColor: Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "DE-NOISE",
                            value: _isDeNoiseEnabled,
                            onChanged: (val) => setState(() => _isDeNoiseEnabled = val),
                            activeColor: Colors.amberAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "X-RAY",
                            value: _isXRayEnabled,
                            onChanged: (val) => setState(() => _isXRayEnabled = val),
                            activeColor: Colors.cyanAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "TELEMETRY",
                            value: _isTelemetryEnabled,
                            onChanged: (val) => setState(() => _isTelemetryEnabled = val),
                            activeColor: Colors.redAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "HEAT-MAP",
                            value: _isHeatMapEnabled,
                            onChanged: (val) => setState(() => _isHeatMapEnabled = val),
                            activeColor: Colors.purpleAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "AUTO-FEED",
                            value: _isAutoScrollEnabled,
                            onChanged: (val) => setState(() => _isAutoScrollEnabled = val),
                            activeColor: Colors.amberAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildControlToggle(
                            label: "SCI-DEPTH",
                            value: _isScientificNotationEnabled,
                            onChanged: (val) => setState(() => _isScientificNotationEnabled = val),
                            activeColor: Colors.cyanAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: SpectrumMode.values.map((mode) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: _buildControlToggle(
                                label: mode.name.toUpperCase(),
                                value: _spectrumMode == mode,
                                onChanged: (val) => setState(() => _spectrumMode = mode),
                                activeColor: _getSpectrumUIInfo(mode).color,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSliderRow(
                        "SCAN RATE",
                        (1001 - _scanSpeedMs.toDouble()).clamp(0, 1000),
                        1000,
                        Colors.amberAccent,
                        (val) {
                          setState(() {
                            _scanSpeedMs = (1001 - val).toInt();
                            _isHyperScanEnabled = false;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildSliderRow(
                        "STABILITY",
                        _stabilityFactor,
                        1.0,
                        Colors.cyanAccent,
                        (val) => setState(() => _stabilityFactor = val),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "DEPTH: ${BureauPrimeSieve.formatBigInt(_highestPrime, scientific: _isScientificNotationEnabled)}",
                                  style: GoogleFonts.cutiveMono(
                                    color: Colors.amberAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "PRIMES DISCOVERED: ${_dossier.discoveries.length}",
                                  style: GoogleFonts.cutiveMono(
                                    color: Colors.white24,
                                    fontSize: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 150, // Adjust width as needed
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.amberAccent.withValues(alpha: 0.2)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                "TERMINATE SCANNER",
                                style: GoogleFonts.cutiveMono(
                                  color: Colors.amberAccent,
                                  fontSize: 10,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OBSERVATIONAL BAY: PRIME-SIEVE",
                style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10, letterSpacing: 1),
              ),
              const SizedBox(height: 2),
              Text(
                "SCAN STATUS: ACTIVE [GIBBONS-SIEVE]",
                style: GoogleFonts.cutiveMono(color: Colors.greenAccent.withValues(alpha: 0.4), fontSize: 8),
              ),
            ],
          ),
          _buildObjectiveIndicator(),
          Row(
            children: [
              _buildSimpleStat("CADENCE", "${_scanSpeedMs}ms"),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "INDEX: ${BureauPrimeSieve.formatBigInt(_highestPrime, scientific: _isScientificNotationEnabled)} | PERFECTS: $_perfectCount",
                    style: GoogleFonts.cutiveMono(color: Colors.redAccent.withValues(alpha: 0.4), fontSize: 8),
                  ),
                  Text(
                    "DENSITY: ${(_primeDensity * 100).toStringAsFixed(1)}% | PI: $_piFragmentCount",
                    style: GoogleFonts.cutiveMono(color: Colors.amberAccent.withValues(alpha: 0.4), fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 8),
        ),
        Text(
          value,
          style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSliderRow(String label, double value, double max, Color color, ValueChanged<double> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cutiveMono(color: color.withValues(alpha: 0.5), fontSize: 8, letterSpacing: 1),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 1,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                activeTrackColor: color,
                inactiveTrackColor: Colors.white10,
                thumbColor: color,
              ),
              child: Slider(
                value: value,
                min: 0,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TARGET PROTOCOLS",
            style: GoogleFonts.cutiveMono(
              color: Colors.white24,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              _objectiveIcon(Icons.star, "PRIME Σ", Colors.amberAccent),
              _objectiveIcon(Icons.diamond, "PERFECT Ω", Colors.cyanAccent),
              _objectiveIcon(Icons.pie_chart, "PI π", Colors.redAccent),
              if (_stencilPattern != null) _objectiveIcon(Icons.psychology_alt, "STENCIL ░", Colors.pinkAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _objectiveIcon(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color.withValues(alpha: 0.8)),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.cutiveMono(
            color: color.withValues(alpha: 0.6),
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showDossier() {
    SmartDialog.show(
      builder: (_) => Container(
        width: 350,
        height: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BUREAU DOSSIER: DISCOVERY LOG",
              style: GoogleFonts.cutiveMono(
                color: Colors.blueAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white10),
            Expanded(
              child: ListView.builder(
                itemCount: _dossier.discoveries.length,
                itemBuilder: (context, index) {
                  final discovery = _dossier.discoveries.reversed.toList()[index];
                  final color = discovery.type == DiscoveryType.prime
                      ? Colors.amberAccent
                      : discovery.type == DiscoveryType.perfect
                      ? Colors.cyanAccent
                      : Colors.redAccent;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "[${discovery.type.name.toUpperCase()}]",
                          style: GoogleFonts.cutiveMono(color: color, fontSize: 10),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "COORD: ${BureauPrimeSieve.formatBigInt(discovery.number, scientific: _isScientificNotationEnabled)}",
                              style: GoogleFonts.cutiveMono(
                                color: Colors.cyanAccent,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "DEPTH: ${BureauPrimeSieve.formatBigInt(discovery.depth, scientific: _isScientificNotationEnabled)}",
                              style: GoogleFonts.cutiveMono(
                                color: Colors.white24,
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => SmartDialog.dismiss(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                ),
                child: Center(
                  child: Text(
                    "CLOSE DOSSIER",
                    style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlToggle({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? activeColor : Colors.white10,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
          color: value ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
        ),
        child: Text(
          label,
          style: GoogleFonts.cutiveMono(
            color: value ? activeColor : Colors.white24,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Future<BigInt?> _parseBigIntInduction(String input) async {
    final clean = input.replaceAll(' ', '').toLowerCase();
    if (clean.isEmpty) return null;

    // Mersenne Pattern Detection Optimization
    final mersenneMatch = RegExp(r'^2\^(\d+)(-1|)$').firstMatch(clean);
    if (mersenneMatch != null) {
      final exp = int.tryParse(mersenneMatch.group(1)!);
      if (exp != null && exp < 500000000) {
        BigInt res = BigInt.one << exp;
        if (mersenneMatch.group(2) == '-1') {
          res -= BigInt.one;
        }
        return res;
      }
    }

    return compute(_parseBigIntExpressionStatic, clean);
  }

  static BigInt? _parseBigIntExpressionStatic(String input) {
    return _parseBigIntExpressionAlgorithm(input);
  }

  static BigInt? _parseBigIntExpressionAlgorithm(String input) {
    if (input.isEmpty) return null;

    try {
      if (input.contains('+')) {
        final parts = input.split('+');
        BigInt result = BigInt.zero;
        for (final p in parts) {
          final val = _parseBigIntExpressionAlgorithm(p);
          if (val == null) return null;
          result += val;
        }
        return result;
      }
      if (input.contains('-')) {
        final parts = input.split('-');
        BigInt? result;
        for (final p in parts) {
          final val = _parseBigIntExpressionAlgorithm(p);
          if (val == null) return null;
          if (result == null) {
            result = val;
          } else {
            result -= val;
          }
        }
        return result;
      }

      if (input.contains('*')) {
        final parts = input.split('*');
        BigInt result = BigInt.one;
        for (final p in parts) {
          final val = _parseBigIntExpressionAlgorithm(p);
          if (val == null) return null;
          result *= val;
        }
        return result;
      }

      if (input.contains('^')) {
        final parts = input.split('^');
        if (parts.length == 2) {
          final base = _parseBigIntExpressionAlgorithm(parts[0]);
          final exp = int.tryParse(parts[1]);
          if (base != null && exp != null) {
            if (exp > 300000000) return null;
            return base.pow(exp);
          }
        }
      }

      if (input.contains('e')) {
        final parts = input.split('e');
        if (parts.length == 2) {
          final base = double.tryParse(parts[0]);
          final exp = int.tryParse(parts[1]);
          if (base != null && exp != null) {
            if (exp > 1000000) return null;
            return (BigInt.from(base) * BigInt.from(10).pow(exp));
          }
        }
      }

      return BigInt.tryParse(input);
    } catch (_) {
      return null;
    }
  }

  ({Color color, String label}) _getSpectrumUIInfo(SpectrumMode mode) {
    switch (mode) {
      case SpectrumMode.standard:
        return (color: Colors.amberAccent, label: "STANDARD");
      case SpectrumMode.uv:
        return (color: Colors.purpleAccent, label: "ULTRAVIOLET");
      case SpectrumMode.ir:
        return (color: Colors.redAccent, label: "INFRARED");
      case SpectrumMode.thermal:
        return (color: Colors.blueAccent, label: "THERMAL");
    }
  }
}
