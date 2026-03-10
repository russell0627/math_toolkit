import 'dart:async';
import 'dart:math' as math;

import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/cipher_ctrl.dart';

class CipherScreen extends ConsumerStatefulWidget {
  const CipherScreen({super.key});

  @override
  ConsumerState<CipherScreen> createState() => _CipherScreenState();
}

class _CipherScreenState extends ConsumerState<CipherScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cipherCtrlProvider);
    final ctrl = ref.read(cipherCtrlProvider.notifier);
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "CIPHER-UNIT: SN-BUREAU-0004",
          style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 12, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "SECURITY CLEARANCE ENABLED",
              style: GoogleFonts.ebGaramond(
                textStyle: styles.labelSmall.copyWith(
                  color: Colors.white70,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Cipher Type Toggle
            Row(
              children: [
                _TypeButton(
                  label: "CAESAR",
                  isSelected: state.type == CipherType.caesar,
                  onTap: () => ctrl.setType(CipherType.caesar),
                ),
                const SizedBox(width: 12),
                _TypeButton(
                  label: "VIGENERE",
                  isSelected: state.type == CipherType.vigenere,
                  onTap: () => ctrl.setType(CipherType.vigenere),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Text Input
            _buildCipherField(
              "MESSAGE PAYLOAD",
              _inputController,
              (val) => ctrl.setInputText(val),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Key Input
            _buildCipherField(
              "ENCRYPTION KEY",
              _keyController,
              (val) => ctrl.setKey(val),
              hint: state.type == CipherType.caesar ? "Numeric Shift (e.g. 3)" : "Alpha Key (e.g. SECRET)",
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ctrl.execute(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("ENCRYPT"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ctrl.execute(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("DECRYPT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Result Display
            if (state.isResultVisible) _JumbledResultDisplay(result: state.resultText),
            const SizedBox(height: 40),
            Text(
              "ENCRYPTION PROTOCOL v8.0",
              style: styles.labelSmall.copyWith(color: Colors.white24, fontSize: 10, letterSpacing: 4),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCipherField(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    int maxLines = 1,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 12),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.3),
            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 1)),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amberAccent.withValues(alpha: 0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? Colors.amberAccent : Colors.white10),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.cutiveMono(
              color: isSelected ? Colors.amberAccent : Colors.white24,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _JumbledResultDisplay extends StatefulWidget {
  final String result;
  const _JumbledResultDisplay({required this.result});

  @override
  State<_JumbledResultDisplay> createState() => _JumbledResultDisplayState();
}

class _JumbledResultDisplayState extends State<_JumbledResultDisplay> {
  late String _currentText;
  Timer? _timer;
  int _iterations = 0;
  final int _maxIterations = 15;

  @override
  void initState() {
    super.initState();
    _startJumble();
  }

  @override
  void didUpdateWidget(_JumbledResultDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result) {
      _startJumble();
    }
  }

  void _startJumble() {
    _timer?.cancel();
    _iterations = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_iterations >= _maxIterations) {
          _currentText = widget.result;
          timer.cancel();
        } else {
          _currentText = String.fromCharCodes(
            List.generate(widget.result.length, (_) => 33 + math.Random().nextInt(94)),
          );
          _iterations++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF050F05),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2), width: 2),
        boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PROCESSED RESULT",
            style: GoogleFonts.cutiveMono(color: Colors.greenAccent.withValues(alpha: 0.5), fontSize: 10),
          ),
          const SizedBox(height: 12),
          Text(
            _currentText,
            style: GoogleFonts.cutiveMono(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [const Shadow(color: Colors.greenAccent, blurRadius: 8)],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.white24, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.result));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("COPIED TO BUFFER"), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
