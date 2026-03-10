import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/presentation/widgets/luminescent_wrapper.dart';
import '../../controller/algebra_ctrl.dart';

class SuggestionChips extends ConsumerWidget {
  const SuggestionChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(algebraCtrlProvider);
    final ctrl = ref.read(algebraCtrlProvider.notifier);

    if (state.suggestions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TACTICAL RECOMMENDATIONS",
          style: GoogleFonts.cutiveMono(color: Colors.blueAccent.withValues(alpha: 0.5), fontSize: 9),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onHover: (hovering) {
                    if (hovering) {
                      // Project outcome for Shadow Audit
                      if (suggestion.op == 'FACTOR') {
                        // For factor, we just show the factored form
                        // In a real impl we'd call _factorExpression, but here we'll just set it
                        // For simplicity in this preview:
                        ctrl.setPreview(null, null); // Skip for now or implement logic
                      } else {
                        final eq = state.equations[state.selectedIndex];
                        final nextLeft = "(${eq.left}) ${suggestion.op} (${suggestion.value})";
                        final nextRight = "(${eq.right}) ${suggestion.op} (${suggestion.value})";
                        ctrl.setPreview(nextLeft, nextRight);
                      }
                    } else {
                      ctrl.setPreview(null, null);
                    }
                  },
                  onTap: () {
                    ctrl.setPreview(null, null);
                    if (suggestion.op == 'FACTOR') {
                      ctrl.factor();
                    } else {
                      ctrl.applyOperation(suggestion.op, suggestion.value);
                    }
                  },
                  child: LuminescentWrapper(
                    blurRadius: 8,
                    glowColor: Colors.blueAccent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.05),
                        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            suggestion.display,
                            style: GoogleFonts.cutiveMono(
                              color: Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            suggestion.justification,
                            style: GoogleFonts.cutiveMono(
                              color: Colors.blueAccent.withValues(alpha: 0.5),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
