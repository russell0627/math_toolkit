import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/element_model.dart';

class ElementCell extends StatelessWidget {
  final BureauElement element;
  final bool isSelected;
  final VoidCallback onTap;

  const ElementCell({
    super.key,
    required this.element,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(element.category);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.2),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              element.atomicNumber.toString(),
              style: GoogleFonts.cutiveMono(color: color.withValues(alpha: 0.6), fontSize: 8),
            ),
            Text(
              element.symbol,
              style: GoogleFonts.cutiveMono(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
                ],
              ),
            ),
            Text(
              element.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 6),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Alkali Metal":
        return Colors.redAccent;
      case "Alkaline Earth Metal":
        return Colors.orangeAccent;
      case "Transition Metal":
        return Colors.pinkAccent;
      case "Post-transition Metal":
        return Colors.purpleAccent;
      case "Metalloid":
        return Colors.greenAccent;
      case "Nonmetal":
        return Colors.cyanAccent;
      case "Halogen":
        return Colors.blueAccent;
      case "Noble Gas":
        return Colors.amberAccent;
      case "Lanthanide":
        return Colors.indigoAccent;
      case "Actinide":
        return Colors.deepOrangeAccent;
      default:
        return Colors.white38;
    }
  }
}
