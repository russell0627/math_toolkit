import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tactile_keypad_button.dart';

class KeypadDialog extends StatefulWidget {
  final String packName;
  final String? code;
  final Function(String) onConfirm;
  final VoidCallback onCancel;

  const KeypadDialog({
    super.key,
    required this.packName,
    this.code,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<KeypadDialog> createState() => _KeypadDialogState();
}

class _KeypadDialogState extends State<KeypadDialog> {
  String _input = "";
  bool _isError = false;
  int _shakeTrigger = 0;
  bool _isSuccess = false;
  bool _isFontPanelOpen = false;
  TextStyle _selectedFont = GoogleFonts.cutiveMono();

  final List<TextStyle> _fonts = [
    GoogleFonts.courierPrime(),
    GoogleFonts.robotoMono(),
    GoogleFonts.spaceMono(),
    GoogleFonts.firaCode(),
    GoogleFonts.jetBrainsMono(),
    GoogleFonts.ibmPlexMono(),
    GoogleFonts.majorMonoDisplay(),
    GoogleFonts.nanumGothicCoding(),
    GoogleFonts.vt323(),
    GoogleFonts.cutiveMono(),
    GoogleFonts.shareTechMono(),
    GoogleFonts.anonymousPro(),
    GoogleFonts.inconsolata(),
    GoogleFonts.sourceCodePro(),
    GoogleFonts.ubuntuMono(),
    GoogleFonts.overpassMono(),
    GoogleFonts.novaMono(),
    GoogleFonts.martianMono(),
    GoogleFonts.victorMono(),
    GoogleFonts.redditMono(),
    GoogleFonts.syneMono(),
  ];

  void _addDigit(String digit) {
    if (_input.length < 12) {
      setState(() {
        _input += digit;
        _isError = false;
      });
    }
  }

  void _backspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
        _isError = false;
      });
    }
  }

  void _submit() {
    // We don't know if it's valid yet, the parent will handle the actual validation.
    // But for a punchy UI, we should probably handle the initial visual fail state if it doesn't match widget.code
    if (widget.code != null && _input != widget.code) {
      setState(() {
        _isError = true;
        _shakeTrigger++;
        _input = "";
      });
      HapticFeedback.vibrate();
      return;
    }

    widget.onConfirm(_input);
    setState(() {
      _isSuccess = true;
      _input = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.textStyles;
    final theme = Theme.of(context);

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The Casing
          Container(
                width: 320,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                    // Beveled edge
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.05),
                      offset: const Offset(-2, -2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Decoration: Screws
                    const Positioned(top: -14, left: -14, child: _ScrewHead()),
                    const Positioned(top: -14, right: -14, child: _ScrewHead()),
                    const Positioned(
                      bottom: -14,
                      left: -14,
                      child: _ScrewHead(),
                    ),
                    const Positioned(
                      bottom: -14,
                      right: -14,
                      child: _ScrewHead(),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top Bar with LEDs
                        Row(
                          children: [
                            const _StatusLED(
                              label: "PWR",
                              color: Colors.redAccent,
                              isOn: true,
                            ),
                            const SizedBox(width: 12),
                            _StatusLED(
                              label: "ACCESS",
                              color: _isSuccess ? Colors.greenAccent : Colors.redAccent,
                              isOn: _isError || _isSuccess,
                              isFlashing: _isError,
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                size: 10,
                                color: Colors.white24,
                              ),
                              onPressed: () => setState(
                                () => _isFontPanelOpen = !_isFontPanelOpen,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const Spacer(),
                            Text(
                              "SN-BUREAU-${(widget.packName.hashCode % 1000).toString().padLeft(4, '0')}",
                              style: styles.labelSmall.copyWith(
                                color: Colors.white24,
                                fontSize: 8,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "CLEARANCE REQUIRED",
                          style: styles.labelSmall.copyWith(
                            color: Colors.white70,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.packName.toUpperCase(),
                          style: styles.labelSmall.copyWith(
                            color: theme.colorScheme.primary,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // CRT Display
                        Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFF050F05),
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: _isError ? Colors.red : Colors.green.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _isError ? "DENIED" : (_input.isEmpty ? "ENTER CODE" : _input),
                                style: _selectedFont.copyWith(
                                  fontSize: 18,
                                  color: _isError ? Colors.red : Colors.greenAccent,
                                  letterSpacing: 4,
                                  shadows: [
                                    Shadow(
                                      color: (_isError ? Colors.red : Colors.greenAccent).withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Scanlines
                            const Positioned.fill(child: _CRTOverlay()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Grid
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
                          children: [
                            for (var i = 1; i <= 9; i++) _buildKey("$i"),
                            _buildKey("X", isAction: true, onTap: _backspace),
                            _buildKey("0"),
                            _buildKey(
                              "OK",
                              isAction: true,
                              onTap: _submit,
                              color: Colors.greenAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: widget.onCancel,
                          child: Text(
                            "TERMINATE REQUEST",
                            style: styles.labelSmall.copyWith(
                              color: Colors.white54,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate(target: _isError ? 1 : 0, key: ValueKey(_shakeTrigger))
              .shake(duration: 400.ms, hz: 8, offset: const Offset(6, 0))
              .tint(color: Colors.red.withValues(alpha: 0.1), duration: 200.ms)
              .then()
              .tint(color: Colors.transparent, duration: 200.ms),

          // Font Selector Panel
          if (_isFontPanelOpen)
            Positioned(
              left: 325,
              top: 40,
              child: Container(
                width: 150,
                height: 380, // Fixed height for scrolling
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "DEBUG: FONTS (21)",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _fonts
                              .map(
                                (font) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedFont = font;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    color: _selectedFont.fontFamily == font.fontFamily
                                        ? Colors.white10
                                        : Colors.transparent,
                                    child: Text(
                                      font.fontFamily ?? "Unknown",
                                      style: font.copyWith(
                                        color: _selectedFont.fontFamily == font.fontFamily
                                            ? Colors.greenAccent
                                            : Colors.white70,
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().slideX(begin: -0.2, duration: 300.ms).fadeIn(),
            ),

          // Sticky Note
          if (widget.code != null)
            Positioned(
              top: -30,
              right: -40,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "FORGETFUL?",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.code!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),
        ],
      ),
    ).animate().scale(duration: 200.ms, curve: Curves.easeOutCubic).fadeIn();
  }

  Widget _buildKey(
    String label, {
    bool isAction = false,
    VoidCallback? onTap,
    Color? color,
  }) {
    return TactileKeypadButton(
      label: label,
      color: color,
      isAction: isAction,
      fontStyle: _selectedFont,
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          _addDigit(label);
        }
      },
    );
  }
}

class _ScrewHead extends StatelessWidget {
  const _ScrewHead();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(1, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 1.5,
          color: Colors.black26,
          transform: Matrix4.rotationZ(0.78),
        ),
      ),
    );
  }
}

class _StatusLED extends StatelessWidget {
  final String label;
  final Color color;
  final bool isOn;
  final bool isFlashing;

  const _StatusLED({
    required this.label,
    required this.color,
    this.isOn = false,
    this.isFlashing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white24,
            fontSize: 6,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isOn ? color : color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: isOn
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
            )
            .animate(
              onPlay: (c) => isFlashing ? c.repeat(reverse: true) : c.stop(),
            )
            .tint(color: Colors.black, end: 0.5, duration: 200.ms),
      ],
    );
  }
}

class _CRTOverlay extends StatelessWidget {
  const _CRTOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              for (var i = 0; i < 30; i++) ...[
                Colors.black.withValues(alpha: i % 2 == 0 ? 0.1 : 0.0),
                Colors.black.withValues(alpha: i % 2 == 0 ? 0.1 : 0.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
