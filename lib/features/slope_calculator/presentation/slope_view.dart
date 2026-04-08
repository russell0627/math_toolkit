import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/slope_ctrl.dart';
import '../model/slope_model.dart';

class SlopeCalculatorView extends ConsumerStatefulWidget {
  const SlopeCalculatorView({super.key});

  @override
  ConsumerState<SlopeCalculatorView> createState() => _SlopeCalculatorViewState();
}

class _SlopeCalculatorViewState extends ConsumerState<SlopeCalculatorView> {
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _yController = TextEditingController();
  final FocusNode _xFocus = FocusNode();
  
  Offset? _hoverOffset;
  int _activeTabIndex = 0;

  void _addPoint() {
    final x = double.tryParse(_xController.text);
    final y = double.tryParse(_yController.text);

    if (x != null && y != null) {
      ref.read(slopeCtrlProvider.notifier).addPoint(x, y);
      _xController.clear();
      _yController.clear();
      _xFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _xFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(slopeCtrlProvider);
    final ctrl = ref.read(slopeCtrlProvider.notifier);

    return Column(
      children: [
        _buildStatusBar(state),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputSection(),
                const SizedBox(height: 32),
                if (state.points.isNotEmpty) ...[
                  _buildPointsList(state, ctrl),
                  const SizedBox(height: 32),
                  _buildVisualizationSection(state),
                  const SizedBox(height: 32),
                ],
                if (state.slope != null || state.equation != null) _buildResultsSection(state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisualizationSection(SlopeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SLP-01 DATA VISUALIZATION",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
            ),
            if (_hoverOffset != null)
              Text(
                "CROSSHAIR: INACTIVE READING",
                style: GoogleFonts.shareTechMono(color: Colors.orangeAccent.withValues(alpha: 0.5), fontSize: 8),
              ),
          ],
        ),
        const SizedBox(height: 12),
        MouseRegion(
          onHover: (event) => setState(() => _hoverOffset = event.localPosition),
          onExit: (_) => setState(() => _hoverOffset = null),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRect(
              child: CustomPaint(
                painter: SlopeGridPainter(state, hoverOffset: _hoverOffset),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(SlopeState state) {
    final hasPoints = state.points.length >= 2;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      color: Colors.orangeAccent.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(
            hasPoints ? Icons.analytics : Icons.hourglass_empty,
            size: 14,
            color: Colors.orangeAccent,
          ),
          const SizedBox(width: 12),
          Text(
            hasPoints ? "AUDIT READY: LINEAR REGRESSION ACTIVE" : "AWAITING SUFFICIENT DATA (MIN 2 POINTS)...",
            style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "COORDINATE INGESTION",
            style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _xController,
                  focusNode: _xFocus,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 18),
                  decoration: _inputDecoration("X Value"),
                  onSubmitted: (_) => _addPoint(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _yController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 18),
                  decoration: _inputDecoration("Y Value"),
                  onSubmitted: (_) => _addPoint(),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _addPoint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.withValues(alpha: 0.1),
                  foregroundColor: Colors.orangeAccent,
                  side: const BorderSide(color: Colors.orangeAccent, width: 0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: const Icon(Icons.add, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: GoogleFonts.shareTechMono(color: Colors.white10),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orangeAccent)),
    );
  }

  Widget _buildPointsList(SlopeState state, SlopeCtrl ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "REGISTERED DATA POINTS",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
            ),
            TextButton(
              onPressed: ctrl.clear,
              child: Text("PURGE ALL", style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 10)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(state.points.length, (i) {
            final p = state.points[i];
            return Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "(${p.x}, ${p.y})",
                    style: GoogleFonts.shareTechMono(color: Colors.orangeAccent, fontSize: 12),
                  ),
                  IconButton(
                    onPressed: () => ctrl.removePoint(i),
                    icon: const Icon(Icons.close, size: 14, color: Colors.white24),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResultsSection(SlopeState state) {
    final isVertical = state.slope == double.infinity;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withValues(alpha: 0.02),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "CALCULATED SLOPE ANALYSIS",
            style: GoogleFonts.shareTechMono(color: Colors.orangeAccent.withValues(alpha: 0.3), fontSize: 10),
          ),
          const SizedBox(height: 24),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMetric(
                  "SLOPE (m)", 
                  isVertical ? "UNDEFINED" : state.slopeFraction ?? "---",
                  subtitle: isVertical ? null : state.slope?.toStringAsFixed(4),
                ),
                const SizedBox(width: 48),
                _buildMetric("INTERCEPT (b)", isVertical ? "---" : state.yIntercept?.toStringAsFixed(4) ?? "---"),
                const SizedBox(width: 48),
                _buildMetric("RISE (Δy)", isVertical ? "---" : state.rise?.toStringAsFixed(2) ?? "---"),
                const SizedBox(width: 48),
                _buildMetric("RUN (Δx)", isVertical ? "0.00" : state.run?.toStringAsFixed(2) ?? "---"),
                const SizedBox(width: 48),
                _buildMetric("DISTANCE (d)", state.distance?.toStringAsFixed(4) ?? "---"),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
             width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.equation ?? "EQUATION PENDING",
                  style: GoogleFonts.shareTechMono(
                    color: Colors.orangeAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                if (state.equation != null) ...[
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: state.equation!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Equation copied to clipboard", style: GoogleFonts.shareTechMono()),
                          backgroundColor: Colors.orangeAccent,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16, color: Colors.orangeAccent),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
          ),
          if (state.segmentDistances.isNotEmpty) ...[
            const SizedBox(height: 48),
            // Secondary Tab Controls
            Row(
              children: [
                _buildTabButton(0, "LINEAR AUDIT", Icons.list_alt),
                const SizedBox(width: 8),
                _buildTabButton(1, "PROPORTIONALITY", Icons.balance),
              ],
            ),
            const SizedBox(height: 24),
            // Tab Content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _activeTabIndex == 0 
                ? _buildSegmentAudit(state) 
                : _buildProportionalityAnalysis(state),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.orangeAccent.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(
            color: isActive ? Colors.orangeAccent : Colors.white10,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.orangeAccent : Colors.white24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.shareTechMono(
                color: isActive ? Colors.orangeAccent : Colors.white24,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProportionalityAnalysis(SlopeState state) {
    if (state.points.isEmpty) return const SizedBox.shrink();

    final isProp = state.isProportional;
    final k = state.proportionalityConstant;
    final kFrac = state.proportionalityFraction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PROPORTIONALITY ANALYSIS",
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isProp ? Colors.greenAccent.withValues(alpha: 0.03) : Colors.redAccent.withValues(alpha: 0.03),
            border: Border.all(color: (isProp ? Colors.greenAccent : Colors.redAccent).withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STATUS: ${isProp ? "EXACT PROPORTIONAL RELATIONSHIP" : "NON-PROPORTIONAL DATA"}",
                        style: GoogleFonts.shareTechMono(
                          color: isProp ? Colors.greenAccent : Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isProp ? "The relationship passes through (0,0) with a constant ratio." : "Data fails the vertical intercept or constant ratio requirement (y=kx).",
                        style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
                      ),
                    ],
                  ),
                  if (isProp) ...[
                    _buildMetric("CONSTANT (k)", kFrac ?? "---", subtitle: k?.toStringAsFixed(4)),
                  ],
                ],
              ),
              if (isProp) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Text(
                    "MODEL: ${kFrac == "1" ? "y = x" : "y = ($kFrac)x"}",
                    style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentAudit(SlopeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SEGMENT & POINT AUDIT LOG",
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1.5),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
                children: [
                  _tableCell("FROM", header: true),
                  _tableCell("TO", header: true),
                  _tableCell("ΔX", header: true),
                  _tableCell("ΔY", header: true),
                  _tableCell("RATIO (y/x)", header: true),
                  _tableCell("M", header: true),
                  _tableCell("DIST", header: true),
                ],
              ),
              ...List.generate(state.segmentDistances.length, (i) {
                final p1 = state.points[i];
                final p2 = state.points[i + 1];
                final mFrac = state.segmentSlopesFractions[i];
                final ratio = state.pointRatios[i+1]?.toStringAsFixed(3) ?? "---";
                return TableRow(
                  children: [
                    _tableCell("(${p1.x}, ${p1.y})"),
                    _tableCell("(${p2.x}, ${p2.y})"),
                    _tableCell(state.segmentRuns[i].toStringAsFixed(2)),
                    _tableCell("${state.segmentRises[i] >= 0 ? '+' : ''}${state.segmentRises[i].toStringAsFixed(2)}"),
                    _tableCell(ratio, color: Colors.blueAccent.withValues(alpha: 0.7)),
                    _tableCell(mFrac, color: Colors.orangeAccent.withValues(alpha: 0.7)),
                    _tableCell(state.segmentDistances[i].toStringAsFixed(2)),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableCell(String text, {bool header = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        text,
        style: GoogleFonts.shareTechMono(
          color: color ?? (header ? Colors.white38 : Colors.white70),
          fontSize: 10,
          fontWeight: header ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMetric(String label, String value, {String? subtitle}) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.shareTechMono(color: Colors.white12, fontSize: 10),
          ),
        ],
      ],
    );
  }
}

class SlopeGridPainter extends CustomPainter {
  final SlopeState state;
  final Offset? hoverOffset;
  SlopeGridPainter(this.state, {this.hoverOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw Subtle Background Grid
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (var i = 0.0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (var i = 0.0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    if (state.points.isEmpty) {
      // Draw default centered axes for idle state
      final axesPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), axesPaint);
      canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), axesPaint);
    }

    if (state.points.isNotEmpty) {
      // 1. Calculate Bounding Box (Data-Driven Zoom)
      final allX = state.points.map((p) => p.x).toList();
      final allY = state.points.map((p) => p.y).toList();

      // Consider regression endpoints for the box
      if (state.slope != null && state.slope != double.infinity && state.yIntercept != null) {
        final minX_ = allX.reduce(math.min);
        final maxX_ = allX.reduce(math.max);
        allY.add(state.slope! * minX_ + state.yIntercept!);
        allY.add(state.slope! * maxX_ + state.yIntercept!);
      }

      final minX = allX.reduce(math.min);
      final maxX = allX.reduce(math.max);
      final minY = allY.reduce(math.min);
      final maxY = allY.reduce(math.max);

      final dataCenterX = (minX + maxX) / 2;
      final dataCenterY = (minY + maxY) / 2;
      final rangeX = math.max(maxX - minX, 2.0); // Min range of 2.0 for breathing room
      final rangeY = math.max(maxY - minY, 2.0);

      // 2. Scaling logic: Map math units to pixels
      const padding = 120.0;
      final viewWidth = size.width - padding;
      final viewHeight = size.height - padding;

      // Maintain 1:1 aspect ratio to preserve slope angle visualization
      final scale = math.min(viewWidth / rangeX, viewHeight / rangeY);

      // Mapping Function
      Offset map(double x, double y) {
        return Offset(
          size.width / 2 + (x - dataCenterX) * scale,
          size.height / 2 - (y - dataCenterY) * scale,
        );
      }

      // 3. Draw Adaptive Axes
      final axesPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.1)
        ..strokeWidth = 1.5;

      final originPos = map(0, 0);
      // Vertical Axis (x=0)
      if (originPos.dx >= 0 && originPos.dx <= size.width) {
        canvas.drawLine(Offset(originPos.dx, 0), Offset(originPos.dx, size.height), axesPaint);
      }
      // Horizontal Axis (y=0)
      if (originPos.dy >= 0 && originPos.dy <= size.height) {
        canvas.drawLine(Offset(0, originPos.dy), Offset(size.width, originPos.dy), axesPaint);
      }

      // --- NEW: Draw Cursor Crosshair ---
      if (hoverOffset != null) {
        final crosshairPaint = Paint()
          ..color = Colors.orangeAccent.withValues(alpha: 0.2)
          ..strokeWidth = 0.5;
        
        // Horizontal line
        canvas.drawLine(Offset(0, hoverOffset!.dy), Offset(size.width, hoverOffset!.dy), crosshairPaint);
        // Vertical line
        canvas.drawLine(Offset(hoverOffset!.dx, 0), Offset(hoverOffset!.dx, size.height), crosshairPaint);

        // Coordinate HUD near cursor
        final tx = (hoverOffset!.dx - size.width / 2) / scale + dataCenterX;
        final ty = (size.height / 2 - hoverOffset!.dy) / scale + dataCenterY;
        _drawLabel(
          canvas, 
          "[${tx.toStringAsFixed(2)}, ${ty.toStringAsFixed(2)}]", 
          hoverOffset!.translate(10, 10), 
          Colors.orangeAccent.withValues(alpha: 0.4),
        );
      }

      // Draw Predicted/Regression Line
      if (state.slope != null && state.yIntercept != null) {
        final linePaint = Paint()
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

        if (state.slope == double.infinity) {
          // Vertical line
          final x = state.points[0].x;
          final pStart = Offset(map(x, 0).dx, 0);
          final pEnd = Offset(map(x, 0).dx, size.height);
          canvas.drawLine(pStart, pEnd, linePaint..color = Colors.orangeAccent.withValues(alpha: 0.3));
        } else {
          // Extend slightly beyond data points
          final x1 = minX - 1;
          final x2 = maxX + 1;
          final y1 = state.slope! * x1 + state.yIntercept!;
          final y2 = state.slope! * x2 + state.yIntercept!;

          final p1 = map(x1, y1);
          final p2 = map(x2, y2);

          canvas.drawLine(p1, p2, linePaint..color = Colors.orangeAccent.withValues(alpha: 0.3));

          // Draw Slope Triangle (Rise/Run)
          if (state.run! != 0) {
            final minXDat = state.points.map((p) => p.x).reduce(math.min);
            final maxXDat = state.points.map((p) => p.x).reduce(math.max);
            
            final trP1 = map(minXDat, state.slope! * minXDat + state.yIntercept!);
            final trP2 = map(maxXDat, state.slope! * maxXDat + state.yIntercept!);
            final trCorner = Offset(trP2.dx, trP1.dy);

            final trianglePaint = Paint()
              ..color = Colors.orangeAccent.withValues(alpha: 0.5)
              ..strokeWidth = 1.5
              ..style = PaintingStyle.stroke;
            
            final path = Path()
              ..moveTo(trP1.dx, trP1.dy)
              ..lineTo(trCorner.dx, trCorner.dy)
              ..lineTo(trP2.dx, trP2.dy);
            
            canvas.drawPath(path, trianglePaint);

            // Labels for Rise/Run
            _drawMidpointLabel(canvas, "RUN: ${state.run!.toStringAsFixed(2)}", trP1, trCorner, Colors.orangeAccent);
            _drawMidpointLabel(canvas, "RISE: ${state.rise!.toStringAsFixed(2)}", trCorner, trP2, Colors.orangeAccent);
            _drawMidpointLabel(
              canvas,
              "DIST: ${state.distance!.toStringAsFixed(2)}",
              trP1,
              trP2,
              Colors.orangeAccent,
              isHypotenuse: true,
            );
          }
        }
      }

      // Draw Individual Points and Segments
      for (int i = 0; i < state.points.length; i++) {
        final p = state.points[i];
        final pos = map(p.x, p.y);
        
        // Draw segment to next point
        if (i < state.points.length - 1) {
          final nextP = state.points[i + 1];
          final nextPos = map(nextP.x, nextP.y);
          
          canvas.drawLine(
            pos, 
            nextPos, 
            Paint()
              ..color = Colors.white.withValues(alpha: 0.2)
              ..strokeWidth = 1
              ..style = PaintingStyle.stroke
          );
        }

        canvas.drawCircle(pos, 4, Paint()..color = Colors.orangeAccent);
        _drawLabel(canvas, "(${p.x}, ${p.y})", pos, Colors.orangeAccent.withValues(alpha: 0.5));
      }
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.shareTechMono(color: color, fontSize: 8),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, pos.translate(6, -12));
  }

  void _drawMidpointLabel(
    Canvas canvas, 
    String text, 
    Offset a, 
    Offset b, 
    Color color, {
    bool isHypotenuse = false,
    bool smaller = false,
  }) {
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.shareTechMono(
          color: isHypotenuse ? Colors.white : color,
          fontSize: isHypotenuse ? 10 : (smaller ? 7 : 9),
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black.withValues(alpha: smaller ? 0.3 : 0.7),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    
    // Offset for hypotenuse to avoid overlap with line
    final offset = isHypotenuse ? const Offset(0, -15) : Offset.zero;
    tp.paint(canvas, mid.translate(-tp.width / 2 + offset.dx, -tp.height / 2 + offset.dy));
  }

  @override
  bool shouldRepaint(covariant SlopeGridPainter oldDelegate) => state != oldDelegate.state;
}
