import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

class AlgebraGuideScreen extends StatelessWidget {
  const AlgebraGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "HANDBOOK: ALGEBRAIC STANDARDS",
          style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 12, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/algebra_guide.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.amberAccent));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR LOADING DOCUMENT", style: GoogleFonts.shareTechMono(color: Colors.redAccent)),
            );
          }

          return Markdown(
            data: snapshot.data ?? "",
            styleSheet: _getBureaucraticTheme(context),
          );
        },
      ),
    );
  }

  MarkdownStyleSheet _getBureaucraticTheme(BuildContext context) {
    return MarkdownStyleSheet(
      h1: GoogleFonts.ebGaramond(color: Colors.amberAccent, fontSize: 28, fontWeight: FontWeight.bold),
      h2: GoogleFonts.ebGaramond(color: Colors.amberAccent.withValues(alpha: 0.8), fontSize: 20, letterSpacing: 2),
      h3: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
      p: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 14, height: 1.5),
      listBullet: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 14),
      blockquote: GoogleFonts.shareTechMono(color: Colors.white60, fontSize: 13, fontStyle: FontStyle.italic),
      blockquoteDecoration: const BoxDecoration(
        color: Colors.black26,
        border: Border(left: BorderSide(color: Colors.amberAccent, width: 4)),
      ),
      blockquotePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      code: GoogleFonts.shareTechMono(
        color: Colors.greenAccent,
        backgroundColor: Colors.black54,
        fontSize: 14,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
    );
  }
}
