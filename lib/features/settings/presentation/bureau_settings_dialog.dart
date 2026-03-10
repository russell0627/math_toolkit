import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/services/theme/theme_service.dart';
import '../../app/presentation/widgets/bureau_toggle.dart';
import '../controller/settings_ctrl.dart';

class BureauSettingsDialog extends ConsumerWidget {
  const BureauSettingsDialog({super.key});

  static void show() {
    SmartDialog.show(
      builder: (_) => const BureauSettingsDialog(),
      alignment: Alignment.center,
      maskColor: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider.select((state) => state.mode));
    final settings = ref.watch(settingsCtrlProvider);
    final settingsCtrl = ref.read(settingsCtrlProvider.notifier);

    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(color: Colors.white10, height: 32),
            _buildSectionHeader("VISUAL ALIGNMENT"),
            const SizedBox(height: 12),
            _buildThemeSelector(ref, themeMode),
            const SizedBox(height: 24),
            _buildSectionHeader("OPERATIONAL PROTOCOLS"),
            const SizedBox(height: 12),
            _buildProtocolToggle(
              "AUTO-APPLY",
              "PROTOCOL-BOLT",
              settings.isAutoApplyMode,
              settingsCtrl.toggleAutoApplyMode,
            ),
            const SizedBox(height: 12),
            _buildProtocolToggle(
              "IMMERSION MODE",
              "SYSTEM-LORE",
              settings.isThematicNames,
              settingsCtrl.toggleThematicNames,
            ),
            const SizedBox(height: 12),
            _buildProtocolToggle(
              "RADICAL OUTPUT",
              "SYSTEM-SURD",
              settings.isRadicalMode,
              settingsCtrl.toggleRadicalMode,
            ),
            const SizedBox(height: 12),
            _buildSideToggle(
              "DRAWER SIDE",
              "SYSTEM-EDGE",
              settings.isDrawerOnRight,
              (_) => settingsCtrl.toggleDrawerSide(),
            ),
            const SizedBox(height: 12),
            _buildSideToggle(
              "EQUATION ENTRY",
              "UNIT-LAYOUT",
              settings.isSplitEntryMode,
              (_) => settingsCtrl.toggleSplitEntry(),
              labelLeft: "UNIFIED",
              labelRight: "SPLIT",
            ),
            const SizedBox(height: 32),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "UNIT CONFIGURATION",
          style: GoogleFonts.ebGaramond(
            color: Colors.amberAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        Text(
          "GLOBAL SETTINGS OVERRIDE",
          style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.cutiveMono(
        color: Colors.white38,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildThemeSelector(WidgetRef ref, ThemeMode currentMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _buildThemeOption(ref, ThemeMode.system, Icons.brightness_auto, currentMode == ThemeMode.system),
          _buildThemeOption(ref, ThemeMode.light, Icons.light_mode, currentMode == ThemeMode.light),
          _buildThemeOption(ref, ThemeMode.dark, Icons.dark_mode, currentMode == ThemeMode.dark),
        ],
      ),
    );
  }

  Widget _buildThemeOption(WidgetRef ref, ThemeMode mode, IconData icon, bool selected) {
    return Expanded(
      child: InkWell(
        onTap: () => ref.read(themeServiceProvider.notifier).onModeChange(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.amberAccent.withValues(alpha: 0.1) : Colors.transparent,
            border: Border(
              right: mode != ThemeMode.dark ? const BorderSide(color: Colors.white10) : BorderSide.none,
            ),
          ),
          child: Icon(
            icon,
            color: selected ? Colors.amberAccent : Colors.white24,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSideToggle(
    String label,
    String code,
    bool isRight,
    ValueChanged<bool> onChanged, {
    String labelLeft = "LEFT",
    String labelRight = "RIGHT",
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.cutiveMono(color: Colors.white70, fontSize: 12)),
              Text(code, style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8)),
            ],
          ),
          BureauToggle(
            value: isRight,
            onChanged: onChanged,
            labelLeft: labelLeft,
            labelRight: labelRight,
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolToggle(String label, String code, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: active ? Colors.amberAccent.withValues(alpha: 0.3) : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.cutiveMono(color: Colors.white70, fontSize: 12)),
                Text(code, style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8)),
              ],
            ),
            Icon(
              active ? Icons.check_box : Icons.check_box_outline_blank,
              color: active ? Colors.amberAccent : Colors.white24,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => SmartDialog.dismiss(),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          "COMMIT CHANGES",
          style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
