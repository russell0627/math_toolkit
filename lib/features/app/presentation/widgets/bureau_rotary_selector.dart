import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BureauRotarySelector extends StatefulWidget {
  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onAdd;

  const BureauRotarySelector({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    required this.onSelected,
    required this.onAdd,
  });

  @override
  State<BureauRotarySelector> createState() => _BureauRotarySelectorState();
}

class _BureauRotarySelectorState extends State<BureauRotarySelector> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(BureauRotarySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _controller.animateToItem(
        widget.selectedIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
      );
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
      children: [
        IconButton(
          onPressed: widget.onAdd,
          icon: const Icon(Icons.add, size: 14, color: Colors.white24),
          tooltip: "ADD NODE",
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Mechanical Texture / Perspective Shadow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              // Selection indicator plate
              Center(
                child: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withValues(alpha: 0.05),
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.amberAccent.withValues(alpha: 0.2)),
                    ),
                  ),
                ),
              ),
              ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  HapticFeedback.selectionClick();
                  widget.onSelected(index);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.itemCount,
                  builder: (context, index) {
                    final isSelected = index == widget.selectedIndex;
                    return Center(
                      child: Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: GoogleFonts.cutiveMono(
                          color: isSelected ? Colors.amberAccent : Colors.white24,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          shadows: isSelected
                              ? [
                                  const Shadow(
                                    color: Colors.amberAccent,
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "NODE",
          style: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 8),
        ),
      ],
    );
  }
}
