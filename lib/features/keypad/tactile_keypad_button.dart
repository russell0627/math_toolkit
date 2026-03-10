import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class TactileKeypadButton extends StatefulWidget {
  final String label;
  final Color? color;
  final bool isAction;
  final VoidCallback onTap;
  final TextStyle fontStyle;
  final bool showLabel;

  const TactileKeypadButton({
    super.key,
    required this.label,
    this.color,
    this.isAction = false,
    required this.onTap,
    required this.fontStyle,
    this.showLabel = true,
  });

  @override
  State<TactileKeypadButton> createState() => _TactileKeypadButtonState();
}

class _TactileKeypadButtonState extends State<TactileKeypadButton> {
  bool _isPressed = false;
  bool _showCue = false;

  void _triggerCue() {
    setState(() => _showCue = true);
    Future.delayed(500.ms, () {
      if (mounted) setState(() => _showCue = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseButtonColor =
        widget.color ??
        (widget.isAction
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.2));

    final borderColor = widget.color?.withValues(alpha: 0.5) ?? Colors.white24;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            HapticFeedback.lightImpact();
            _triggerCue();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            HapticFeedback.mediumImpact();
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: 60.ms,
            curve: Curves.easeOut,
            margin: EdgeInsets.only(top: _isPressed ? 10 : 0),
            decoration: inset.BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.4, 1.0],
                colors: _isPressed
                    ? [
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.transparent,
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.12),
                        Colors.black.withValues(alpha: 0.25),
                      ],
              ),
              color: baseButtonColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isPressed ? Colors.black45 : borderColor,
                width: 1.5,
              ),
              boxShadow: _isPressed
                  ? [
                      // Deep Inset Shadow (The "Sinking" feel)
                      inset.BoxShadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                        spreadRadius: -2,
                        inset: true,
                      ),
                      inset.BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                        inset: true,
                      ),
                    ]
                  : [
                      // 1. The Physical Height (Dark, sharp base)
                      inset.BoxShadow(
                        color: Colors.black.withValues(alpha: 0.95),
                        offset: const Offset(0, 10),
                        blurRadius: 0,
                      ),
                      // 2. The Side Panel (Mid-tone)
                      inset.BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(0, 5),
                        blurRadius: 0,
                      ),
                      // 3. Ambient Depth
                      inset.BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        offset: const Offset(0, 14),
                        blurRadius: 18,
                        spreadRadius: -4,
                      ),
                      // 4. Inner Bevel Highlight
                      inset.BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        inset: true,
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: widget.showLabel
                ? Text(
                    widget.label,
                    style: widget.fontStyle.copyWith(
                      color:
                          widget.color ??
                          (widget.isAction ? Colors.white70 : Colors.white),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.8),
                          offset: _isPressed
                              ? const Offset(0, 0)
                              : const Offset(0, 1),
                          blurRadius: _isPressed ? 2 : 1,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        if (_showCue) const Positioned(top: -10, left: 10, child: BeepCue()),
      ],
    );
  }
}

class BeepCue extends StatelessWidget {
  const BeepCue({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Text(
        "-click-",
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 8,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
      ),
    )
        .animate()
        .slideY(begin: 0, end: -2.5, duration: 600.ms, curve: Curves.easeOutCubic)
        .slideX(begin: 0, end: (math.Random().nextDouble() - 0.5) * 2, duration: 600.ms)
        .fadeOut(duration: 600.ms);
  }
}
