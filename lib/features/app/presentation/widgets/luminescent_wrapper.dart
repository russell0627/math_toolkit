import 'package:flutter/material.dart';

class LuminescentWrapper extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double blurRadius;
  final double spreadRadius;
  final Duration duration;

  const LuminescentWrapper({
    super.key,
    required this.child,
    this.glowColor = Colors.amberAccent,
    this.blurRadius = 15.0,
    this.spreadRadius = 1.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<LuminescentWrapper> createState() => _LuminescentWrapperState();
}

class _LuminescentWrapperState extends State<LuminescentWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.15 * _animation.value),
                blurRadius: widget.blurRadius * _animation.value,
                spreadRadius: widget.spreadRadius * _animation.value,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
