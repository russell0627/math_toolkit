import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../core/signal_processor.dart';
import 'widgets/waterfall_matrix.dart';
import 'widgets/tactical_console.dart';
import 'widgets/regional_density_oscilloscope.dart';
import 'dart:async';
import 'dart:ui';

class SignalAuditorScreen extends StatefulWidget {
  const SignalAuditorScreen({super.key});

  @override
  State<SignalAuditorScreen> createState() => _SignalAuditorScreenState();
}

class _SignalAuditorScreenState extends State<SignalAuditorScreen> {
  final SignalProcessor _processor = SignalProcessor(poolSize: 4);
  final List<int> _rawBytes = [];
  final List<bool> _matches = [];

  SignalType _activeType = SignalType.prng;
  int _baudRate = 500;
  String? _stencil;
  double _anomalyDensity = 0.0;
  bool _isConsoleExpanded = false;
  bool _isTurboAuditEnabled = false;
  int _cachedBaudRate = 500;

  late Timer _generationTimer;
  final TextEditingController _stencilController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _processor.init();
    _processor.results.listen(_handleResult);

    _startGeneration();
  }

  void _startGeneration() {
    final intervalMs = _isTurboAuditEnabled ? 10 : 1000 ~/ (_baudRate / 100).clamp(1, 100).toInt();
    _generationTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      _processor.requestData(
        SignalRequest(
          type: _activeType,
          byteCount: _isTurboAuditEnabled ? 200 : 50,
          pattern: _stencil,
        ),
      );
    });
  }

  void _handleResult(SignalResult result) {
    if (!mounted) return;
    setState(() {
      _rawBytes.addAll(result.bytes);
      _matches.addAll(result.patternMatches);

      // Keep buffer manageable
      if (_rawBytes.length > 5000) {
        _rawBytes.removeRange(0, 100);
        _matches.removeRange(0, 100);
      }

      int matchCount = result.patternMatches.where((m) => m).length;
      _anomalyDensity = (matchCount / result.bytes.length) * 100;
    });
  }

  @override
  void dispose() {
    _generationTimer.cancel();
    _processor.dispose();
    _stencilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The Waterfall background
          Positioned.fill(
            child: WaterfallMatrix(
              bytes: _rawBytes,
              matches: _matches,
              baseColor: _getSignalColor(_activeType).withOpacity(0.3),
              highlightColor: Colors.pinkAccent,
            ),
          ),

          // HUD Overlay
          SafeArea(
            child: Column(
              children: [
                _buildHeaderBar(),
                TacticalConsole(
                  isExpanded: _isConsoleExpanded,
                  onToggle: () => setState(() => _isConsoleExpanded = !_isConsoleExpanded),
                  child: Column(
                    children: [
                      _buildStats(),
                      const SizedBox(height: 20),
                      _buildControls(),
                      const SizedBox(height: 20),
                      _buildFooter(),
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
                "OBSERVATIONAL BAY 3",
                style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10, letterSpacing: 1),
              ),
              Text(
                "SIGNAL AUDITOR [ACTIVE]",
                style: GoogleFonts.cutiveMono(
                  color: _getSignalColor(_activeType).withValues(alpha: 0.4),
                  fontSize: 8,
                ),
              ),
            ],
          ),
          _buildObjectiveIndicator(),
          Row(
            children: [
              _buildSimpleStat(
                "INTERVAL",
                "${_isTurboAuditEnabled ? 10 : 1000 ~/ (_baudRate / 100).clamp(1, 100).toInt()}ms",
              ),
              const SizedBox(width: 16),
              _buildSimpleStat("BAUD", "$_baudRate"),
              const SizedBox(width: 16),
              _buildSimpleStat("ANOMALY", "${(_anomalyDensity * 100).toStringAsFixed(1)}%"),
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
              _objectiveIcon(Icons.star, _activeType.name.toUpperCase(), _getSignalColor(_activeType)),
              if (_stencil != null) _objectiveIcon(Icons.radar, "STENCIL ░", Colors.pinkAccent),
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

  Widget _buildStats() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          RegionalDensityOscilloscope(
            latestValue: _anomalyDensity,
            label: "SIGNAL ANOMALY (%)",
            color: _getSignalColor(_activeType),
          ),
          const SizedBox(height: 8),
          _statRow("DATA THRUPUT", "${(_baudRate * 1.2).toStringAsFixed(0)} B/S"),
          _statRow("BUFFER DEPTH", "${_rawBytes.length} BYTES"),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.cutiveMono(color: Colors.white12, fontSize: 8)),
        Text(value, style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: 8)),
      ],
    );
  }

  Widget _buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: SignalType.values.map((type) {
            final active = _activeType == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _toggleButton(
                label: type.name.toUpperCase(),
                active: active,
                onTap: () {
                  setState(() {
                    _activeType = type;
                    _rawBytes.clear();
                    _matches.clear();
                  });
                },
                color: _getSignalColor(type),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent.withOpacity(0.2)),
            color: Colors.pinkAccent.withOpacity(0.05),
          ),
          child: TextField(
            controller: _stencilController,
            style: GoogleFonts.cutiveMono(color: Colors.pinkAccent, fontSize: 10),
            onChanged: (val) {
              setState(() => _stencil = val.isEmpty ? null : val);
            },
            decoration: InputDecoration(
              hintText: "SIGNAL STENCIL (e.g. *F0*)",
              hintStyle: GoogleFonts.cutiveMono(color: Colors.pinkAccent.withOpacity(0.2), fontSize: 10),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.radar, size: 14, color: Colors.pinkAccent),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _toggleButton(
          label: "TURBO-AUDIT [!]",
          active: _isTurboAuditEnabled,
          onTap: () {
            setState(() {
              _isTurboAuditEnabled = !_isTurboAuditEnabled;
              if (_isTurboAuditEnabled) {
                _cachedBaudRate = _baudRate;
                _baudRate = 2000;
              } else {
                _baudRate = _cachedBaudRate;
              }
              _generationTimer.cancel();
              _startGeneration();
            });
          },
          color: Colors.redAccent,
        ),
        const SizedBox(height: 12),
        _baudSlider(),
      ],
    );
  }

  Widget _baudSlider() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          Text("BAUD", style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8)),
          Expanded(
            child: Slider(
              value: _baudRate.toDouble(),
              min: 100,
              max: 2000,
              activeColor: _getSignalColor(_activeType),
              onChanged: (val) {
                setState(() {
                  _baudRate = val.toInt();
                  _isTurboAuditEnabled = false;
                  _generationTimer.cancel();
                  _startGeneration();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: active ? color : Colors.white10),
          color: active ? color.withOpacity(0.1) : Colors.transparent,
        ),
        child: Text(
          label,
          style: GoogleFonts.cutiveMono(color: active ? color : Colors.white24, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => context.pop(),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white10)),
        child: Text("TERMINATE AUDIT", style: GoogleFonts.cutiveMono(color: Colors.white24, letterSpacing: 4)),
      ),
    );
  }

  Color _getSignalColor(SignalType type) {
    switch (type) {
      case SignalType.prng:
        return Colors.greenAccent;
      case SignalType.xorPulse:
        return Colors.blueAccent;
      case SignalType.cellularRule30:
        return Colors.amberAccent;
    }
  }
}
