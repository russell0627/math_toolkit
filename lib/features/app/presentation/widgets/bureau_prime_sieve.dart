import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../core/sieve_processor.dart';
import '../../services/dossier_service.dart';
import 'bureau_stamp.dart';
import 'regional_density_oscilloscope.dart';
import '../../../../app_config.dart';
import 'dart:math' as math;

enum SpectrumMode { standard, uv, ir, thermal }

class BureauPrimeSieve extends StatefulWidget {
  final ValueChanged<BigInt>? onHighestPrimeChanged;
  final ValueChanged<double>? onDensityChanged;
  final ValueChanged<int>? onPerfectCountChanged;
  final ValueChanged<int>? onPiFragmentDetected;
  final bool isDeNoiseEnabled;
  final bool isXRayEnabled;
  final bool isTelemetryEnabled;
  final bool isHeatMapEnabled;
  final int scanSpeedMs;
  final double stabilityFactor;
  final SpectrumMode spectrumMode;
  final String? pattern;
  final DossierService? dossier;
  final bool isAutoScrollEnabled;
  final bool isScientificNotationEnabled;

  const BureauPrimeSieve({
    super.key,
    this.onHighestPrimeChanged,
    this.onDensityChanged,
    this.onPerfectCountChanged,
    this.onPiFragmentDetected,
    this.isDeNoiseEnabled = false,
    this.isXRayEnabled = false,
    this.isTelemetryEnabled = false,
    this.isHeatMapEnabled = false,
    this.scanSpeedMs = 150,
    this.stabilityFactor = 1.0,
    this.spectrumMode = SpectrumMode.standard,
    this.pattern,
    this.dossier,
    this.isAutoScrollEnabled = false,
    this.isScientificNotationEnabled = true,
  });

  @override
  BureauPrimeSieveState createState() => BureauPrimeSieveState();

  static String formatBigInt(BigInt n, {bool scientific = false}) {
    // Estimating digits via bitLength: bitLength * log10(2) ~= bitLength * 0.301
    final estimatedDigits = (n.bitLength * 30103) ~/ 100000;

    if (scientific && estimatedDigits > 6) {
      if (estimatedDigits > 15000) {
        // Massive numbers: toString() is dangerous
        return "~1.0e$estimatedDigits";
      }
      final s = n.toString();
      final exponent = s.length - 1;
      final mantissa = s.length > 2 ? "${s[0]}.${s.substring(1, 3)}" : s[0];
      return "${mantissa}e$exponent";
    }

    if (estimatedDigits > 500) {
      return "[EXTREME] (~$estimatedDigits DIGITS)";
    }

    final s = n.toString();
    if (s.length > 20) {
      return '${s.substring(0, 6)}...${s.substring(s.length - 6)} (${s.length}D)';
    }
    return s;
  }
}

class BureauPrimeSieveState extends State<BureauPrimeSieve> with SingleTickerProviderStateMixin {
  final Set<BigInt> _primes = {};
  final Set<BigInt> _perfectNumbers = {};
  final Set<BigInt> _piFragments = {};
  final Set<BigInt> _stampedNumbers = {};
  final Set<BigInt> _patternMatches = {};
  final Map<BigInt, List<BigInt>> _divisorsCache = {};

  BigInt _highestNumberProcessed = BigInt.one;
  BigInt _highestPrime = BigInt.one;
  int _currentScanIndex = 0;
  int _currentSessionId = 0;
  final List<BigInt> _numbers = [];

  // Benchmark tracking
  int _numbersProcessedInWindow = 0;
  DateTime _lastBenchmarkUpdate = DateTime.now();
  double _opsPerSec = 0;
  double _recentAnomalyDensity = 0;
  int _anomaliesInWindow = 0;

  final SieveProcessor _processor = SieveProcessor(poolSize: 4);

  // Spigot State Variables for Pi calculation
  BigInt _q = BigInt.one;
  BigInt _r = BigInt.zero;
  BigInt _t = BigInt.one;
  BigInt _k = BigInt.one;
  BigInt _n = BigInt.from(3);
  BigInt _l = BigInt.from(3);

  final List<int> _piCachedDigits = [];

  late AnimationController _scannerController;
  final ScrollController _scrollController = ScrollController();
  final math.Random _random = math.Random();

  static const int _batchSize = 300;
  static const double _fontSize = 24;
  static const double _digitSpacing = 8;
  static const double _estimatedDigitWidth = _fontSize * 1.2;

  @override
  void initState() {
    super.initState();
    _processor.init();
    _processor.results.listen(_handleIsolateResult);

    _scannerController =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.scanSpeedMs),
        )..addListener(() {
          if (_scannerController.isCompleted) {
            // Hyper-Scan Burst Logic
            final int burst = widget.scanSpeedMs <= 5 ? 20 : 1;
            for (int i = 0; i < burst; i++) {
              _advanceScanner();
            }
            _scannerController.forward(from: 0.0);
          }
        });

    _generateNumbers(BigInt.from(2), 200);
    _scannerController.forward();
  }

  @override
  void didUpdateWidget(BureauPrimeSieve oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scanSpeedMs != widget.scanSpeedMs) {
      _scannerController.duration = Duration(milliseconds: widget.scanSpeedMs);
    }
    if (oldWidget.pattern != widget.pattern) {
      _patternMatches.clear();
      // Re-scan current batch if pattern changes?
      // For now, clear matches and let future scans pick it up.
    }
  }

  void _handleIsolateResult(SieveResult result) {
    if (!mounted) return;
    if (result.sessionId != _currentSessionId) return; // Discard stale induction

    setState(() {
      if (result.isPrime) {
        _anomaliesInWindow++;
        _primes.add(result.number);
        if (widget.isTelemetryEnabled) {
          log.info("[BUREAU AUDIT] Prime Discovered: ${result.number} (Depth: $_highestNumberProcessed)");
        }
        widget.dossier?.recordDiscovery(
          number: result.number,
          type: DiscoveryType.prime,
          depth: _highestNumberProcessed,
        );
        if (result.number > _highestPrime) {
          _highestPrime = result.number;
          widget.onHighestPrimeChanged?.call(_highestPrime);
        }
      }
      if (result.isPerfect) {
        _anomaliesInWindow++;
        if (!_perfectNumbers.contains(result.number)) {
          _stampedNumbers.add(result.number);
          widget.dossier?.recordDiscovery(
            number: result.number,
            type: DiscoveryType.perfect,
            depth: _highestNumberProcessed,
          );
        }
        _perfectNumbers.add(result.number);
        widget.onPerfectCountChanged?.call(_perfectNumbers.length);
      }
      if (result.isPiFragment) {
        _anomaliesInWindow++;
        if (!_piFragments.contains(result.number)) {
          _stampedNumbers.add(result.number);
          widget.dossier?.recordDiscovery(
            number: result.number,
            type: DiscoveryType.piFragment,
            depth: _highestNumberProcessed,
          );
        }
        _piFragments.add(result.number);
        widget.onPiFragmentDetected?.call(_piFragments.length);
      }
      if (result.isPatternMatch) {
        _patternMatches.add(result.number);
      }
      if (result.divisors != null) {
        _divisorsCache[result.number] = result.divisors!;
        _showForensicReport(result);
      }

      _numbersProcessedInWindow++;
      final now = DateTime.now();
      final diff = now.difference(_lastBenchmarkUpdate).inMilliseconds;
      if (diff >= 1000) {
        _opsPerSec = (_numbersProcessedInWindow / (diff / 1000.0));
        _recentAnomalyDensity = (_anomaliesInWindow / math.max(1, _numbersProcessedInWindow)) * 100;
        _numbersProcessedInWindow = 0;
        _anomaliesInWindow = 0;
        _lastBenchmarkUpdate = now;
      }

      if (result.number > _highestNumberProcessed) {
        _highestNumberProcessed = result.number;
        final primeCount = _primes.length;
        widget.onDensityChanged?.call(primeCount / _highestNumberProcessed.toDouble());
      }
    });
  }

  void _generateNumbers(BigInt start, int count) {
    for (int i = 0; i < count; i++) {
      _numbers.add(start + BigInt.from(i));
    }
  }

  void jumpToIndex(BigInt index) {
    BigInt start = index < BigInt.two ? BigInt.two : index;
    setState(() {
      _currentSessionId++; // Increment session to invalidate background buffer
      _numbers.clear();
      _highestNumberProcessed = start - BigInt.one;
      _currentScanIndex = 0;
      _generateNumbers(start, 200);
      _scannerController.forward(from: 0.0);
    });
  }

  void _advanceScanner() {
    if (!mounted) return;

    setState(() {
      final number = _numbers[_currentScanIndex];
      _processNumber(number);
      _currentScanIndex++;

      // Infinite generation
      if (_currentScanIndex > _numbers.length - 50) {
        _generateNumbers(_numbers.last + BigInt.one, _batchSize);
      }

      if (widget.isAutoScrollEnabled && _scrollController.hasClients) {
        // Hydraulic Feed: Sync scroll position with scan index
        // We need to know column count for precise row mapping
        final double availableWidth = MediaQuery.of(context).size.width - 32;
        final int columns = (availableWidth / (_estimatedDigitWidth + _digitSpacing)).floor().clamp(1, 10);

        final double itemWidth = (availableWidth - (columns - 1) * 8) / columns;
        final double rowHeight = (itemWidth / 1.5) + 8; // height = width/aspectRatio + spacing
        final double targetScroll = (_currentScanIndex / columns).floor() * rowHeight;

        _scrollController.animateTo(
          targetScroll,
          duration: Duration(milliseconds: widget.scanSpeedMs),
          curve: Curves.linear,
        );
      }
    });
  }

  void _processNumber(BigInt n, {bool includeDivisors = false}) {
    _ensurePiDigits(n.toString().length);
    _processor.requestAnalysis(
      SieveRequest(
        numbers: [n],
        includeDivisors: includeDivisors,
        currentPiDigits: _piCachedDigits,
        pattern: widget.pattern,
        sessionId: _currentSessionId,
      ),
    );
  }

  void _showForensicReport(SieveResult result) {
    SmartDialog.show(
      builder: (_) => Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "BUREAU FORENSIC REPORT",
              style: GoogleFonts.cutiveMono(
                color: Colors.cyanAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            _reportRow("TARGET INDEX", result.number.toString()),
            _reportRow("PRIMALITY", result.isPrime ? "VERIFIED" : "NEGATIVE"),
            _reportRow("HARMONIC", result.isPerfect ? "AUTHENTICATED" : "INACTIVE"),
            _reportRow("PI ALIGNMENT", result.isPiFragment ? "CRITICAL" : "STANDARD"),
            const SizedBox(height: 12),
            Text(
              "DIVISORS:",
              style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              result.divisors?.join(', ') ?? "NONE",
              style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 10),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => SmartDialog.dismiss(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                ),
                child: Center(
                  child: Text(
                    "ACKNOWLEDGE",
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

  Widget _reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 10)),
          Text(value, style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  void _ensurePiDigits(int count) {
    if (count > 5000) count = 5000; // Hard cap for stability
    while (_piCachedDigits.length < count) {
      if (BigInt.from(4) * _q + _r - _t < _n * _t) {
        _piCachedDigits.add(_n.toInt());
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
  }

  @override
  void dispose() {
    _processor.dispose();
    _scannerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isHeatMapEnabled)
          Positioned.fill(
            child: CustomPaint(
              painter: _HeatMapPainter(
                numbers: _numbers,
                primes: _primes,
              ),
            ),
          ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              color: Colors.black.withValues(alpha: 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _benchMarkText("OPS/SEC", _opsPerSec.toStringAsFixed(0)),
                  _benchMarkText("LOAD", "${((_opsPerSec / 2000) * 100).toStringAsFixed(1)}%"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              color: Colors.black.withValues(alpha: 0.6),
              child: RegionalDensityOscilloscope(
                latestValue: _recentAnomalyDensity,
                label: "ANOMALY DENSITY (%)",
                color: Colors.cyanAccent,
              ),
            ),
            Expanded(
              child: _buildGrid(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _benchMarkText(String label, String value) {
    return Text(
      "$label: $value",
      style: GoogleFonts.cutiveMono(
        color: Colors.white12,
        fontSize: 8,
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth - 32;
        final columns = (availableWidth / (_estimatedDigitWidth + _digitSpacing)).floor().clamp(1, 10);

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
          ),
          itemCount: _numbers.length,
          itemBuilder: (context, index) {
            final number = _numbers[index];
            final isScanning = index == _currentScanIndex;
            final isPrime = _primes.contains(number);
            final isPerfect = _perfectNumbers.contains(number);
            final isPiFragment = _piFragments.contains(number);
            final isPatternMatch = _patternMatches.contains(number);
            final isPast = index < _currentScanIndex;

            // X-Ray check
            final divisors = _divisorsCache[number];

            // Filter: De-Noise
            if (widget.isDeNoiseEnabled && !isPrime && !isPerfect && !isPiFragment && !isScanning) {
              return const SizedBox.shrink();
            }

            // Hardware Stress: Scaling with depth + Stability Dampening (Inverted for intuition)
            final double stressFactor =
                math.min(1.0, _highestNumberProcessed.toDouble() / 10000) * (1.0 - widget.stabilityFactor);
            final double jitterX = (isScanning || isPast) ? (_random.nextDouble() - 0.5) * 2 * stressFactor : 0.0;
            final double jitterY = (isScanning || isPast) ? (_random.nextDouble() - 0.5) * 2 * stressFactor : 0.0;
            final double flicker = (isScanning || isPast) ? 1.0 - (_random.nextDouble() * 0.2 * stressFactor) : 1.0;

            final Color accentColor = _getSpectrumColor(
              number: number,
              isPrime: isPrime,
              isPerfect: isPerfect,
              isPiFragment: isPiFragment,
              isPatternMatch: isPatternMatch,
              isScanning: isScanning,
              isPast: isPast,
            );

            return Transform.translate(
              offset: Offset(jitterX, jitterY),
              child: Opacity(
                opacity: flicker,
                child: Tooltip(
                  message: divisors != null ? "DIVISORS: ${divisors.join(', ')}" : "",
                  triggerMode: TooltipTriggerMode.longPress,
                  child: GestureDetector(
                    onLongPress: () {
                      if (widget.isXRayEnabled) {
                        _processNumber(number, includeDivisors: true);
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isScanning ? accentColor.withValues(alpha: 0.2) : Colors.transparent,
                            border: Border.all(
                              color: isScanning
                                  ? accentColor
                                  : isPiFragment
                                  ? accentColor.withValues(alpha: 0.8)
                                  : isPerfect
                                  ? accentColor.withValues(alpha: 0.6)
                                  : isPrime
                                  ? accentColor.withValues(alpha: 0.3)
                                  : isPatternMatch
                                  ? Colors.pinkAccent
                                  : Colors.white10,
                              width: isScanning ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: isPrime || isPerfect || isPiFragment
                                ? [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.1),
                                      blurRadius: isPiFragment
                                          ? 20
                                          : isPerfect
                                          ? 15
                                          : 10,
                                      spreadRadius: isPiFragment
                                          ? 4
                                          : isPerfect
                                          ? 3
                                          : 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              BureauPrimeSieve.formatBigInt(
                                number,
                                scientific: widget.isScientificNotationEnabled,
                              ),
                              style: GoogleFonts.cutiveMono(
                                color: accentColor,
                                fontSize: widget.isScientificNotationEnabled ? 12 : 16,
                                fontWeight: isPrime || isScanning || isPerfect || isPiFragment
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        if (_stampedNumbers.contains(number))
                          Positioned(
                            top: -10,
                            right: -5,
                            child: BureauStamp(
                              type: isPiFragment ? StampType.critical : StampType.authenticated,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeatMapPainter extends CustomPainter {
  final List<BigInt> numbers;
  final Set<BigInt> primes;

  _HeatMapPainter({required this.numbers, required this.primes});

  @override
  void paint(Canvas canvas, Size size) {
    if (numbers.isEmpty) return;

    final paint = Paint()
      ..color = Colors.amberAccent.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final random = math.Random(42);
    for (int i = 0; i < numbers.length; i++) {
      if (primes.contains(numbers[i])) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        canvas.drawCircle(Offset(x, y), 30, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatMapPainter oldDelegate) => true;
}

extension _SpectrumLogic on BureauPrimeSieveState {
  Color _getSpectrumColor({
    required BigInt number,
    required bool isPrime,
    required bool isPerfect,
    required bool isPiFragment,
    required bool isPatternMatch,
    required bool isScanning,
    required bool isPast,
  }) {
    if (isPatternMatch && !isScanning) return Colors.pinkAccent;

    switch (widget.spectrumMode) {
      case SpectrumMode.uv:
        if (isPiFragment) return Colors.pinkAccent;
        if (isPerfect) return Colors.lightBlueAccent;
        if (isScanning) return Colors.white;
        if (isPrime) return Colors.purpleAccent;
        return isPast ? Colors.purple.withValues(alpha: 0.3) : Colors.white10;

      case SpectrumMode.ir:
        if (isPiFragment) return Colors.red;
        if (isPerfect) return Colors.orangeAccent;
        if (isScanning) return Colors.yellow;
        if (isPrime) return Colors.deepOrangeAccent;
        return isPast ? Colors.red.withValues(alpha: 0.2) : Colors.white10;

      case SpectrumMode.thermal:
        if (isPiFragment) return Colors.white;
        if (isPerfect) return Colors.yellowAccent;
        if (isScanning) return Colors.cyanAccent;
        if (isPrime) return Colors.redAccent;
        return isPast ? Colors.blueAccent.withValues(alpha: 0.3) : Colors.blueGrey;

      case SpectrumMode.standard:
        if (isPiFragment) return Colors.redAccent;
        if (isPerfect) return Colors.cyanAccent;
        if (isScanning) return Colors.white;
        if (isPrime) return Colors.amberAccent;
        return isPast ? Colors.white24 : Colors.white10;
    }
  }
}
