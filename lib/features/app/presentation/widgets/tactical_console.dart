import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TacticalConsole extends StatefulWidget {
  final Widget child;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String label;

  const TacticalConsole({
    super.key,
    required this.child,
    required this.isExpanded,
    required this.onToggle,
    this.label = "DIAGNOSTICS",
  });

  @override
  State<TacticalConsole> createState() => _TacticalConsoleState();
}

class _TacticalConsoleState extends State<TacticalConsole> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(TacticalConsole oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              border: Border.all(color: Colors.white10),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 14,
                  color: Colors.white24,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.label,
                  style: GoogleFonts.cutiveMono(
                    color: Colors.white24,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              );
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  border: const Border(
                    bottom: BorderSide(color: Colors.white10),
                    left: BorderSide(color: Colors.white10),
                    right: BorderSide(color: Colors.white10),
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
