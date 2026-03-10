import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BureauToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String labelLeft;
  final String labelRight;

  const BureauToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelLeft = "DEC",
    this.labelRight = "RAT",
  });

  @override
  State<BureauToggle> createState() => _BureauToggleState();
}

class _BureauToggleState extends State<BureauToggle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _toggleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _toggleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(BureauToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.value ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.white10, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Labels background
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      widget.labelLeft,
                      style: GoogleFonts.cutiveMono(
                        color: !widget.value ? Colors.amberAccent.withValues(alpha: 0.5) : Colors.white10,
                        fontSize: 7,
                        fontWeight: !widget.value ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.labelRight,
                      style: GoogleFonts.cutiveMono(
                        color: widget.value ? Colors.amberAccent.withValues(alpha: 0.5) : Colors.white10,
                        fontSize: 7,
                        fontWeight: widget.value ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Mechanical Switch (Slider)
            AnimatedBuilder(
              animation: _toggleAnimation,
              builder: (context, child) {
                return Positioned(
                  left: 1 + (_toggleAnimation.value * 32),
                  top: 1,
                  bottom: 1,
                  child: Container(
                    width: 25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[800]!,
                          Colors.grey[900]!,
                          Colors.black,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 1,
                        color: Colors.white10,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
