import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/notepad_ctrl.dart';

class NotepadView extends ConsumerStatefulWidget {
  const NotepadView({super.key});

  @override
  ConsumerState<NotepadView> createState() => _NotepadViewState();
}

class _NotepadViewState extends ConsumerState<NotepadView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(notepadCtrlProvider);

    if (_controller.text != content) {
      _controller.text = content;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (val) => ref.read(notepadCtrlProvider.notifier).updateContent(val),
        maxLines: null,
        expands: true,
        style: GoogleFonts.shareTechMono(
          color: Colors.white70,
          fontSize: 12,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: "ENTER OBSERVATIONS...",
          hintStyle: GoogleFonts.shareTechMono(color: Colors.white10),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
