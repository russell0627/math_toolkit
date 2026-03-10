import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/presentation/widgets/bureau_atmosphere.dart';
import '../../algebra/presentation/algebra_view.dart';
import '../../pythagorean/presentation/pythagorean_view.dart';
import '../../radical_simplifier/presentation/radical_view.dart';
import '../../triangle_solver/presentation/triangle_view.dart';
import '../../grid_pythagorean/presentation/grid_pythagorean_view.dart';
import '../../reflection_mapper/presentation/reflection_view.dart';
import '../../rotation_mapper/presentation/rotation_view.dart';
import '../../transformation_sequence/presentation/transformation_sequence_view.dart';
import '../../settings/controller/settings_ctrl.dart';
import '../controller/workbench_ctrl.dart';
import '../model/workbench_model.dart';
import 'widgets/mini_calculator_view.dart';
import 'widgets/notepad_view.dart';

class WorkbenchScreen extends ConsumerWidget {
  const WorkbenchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workbenchCtrlProvider);
    final settings = ref.watch(settingsCtrlProvider);
    final ctrl = ref.read(workbenchCtrlProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BureauAtmosphere(
        child: SafeArea(
          child: Row(
            children: [
              _buildSidebar(context, state, ctrl, settings),
              const VerticalDivider(width: 1, color: Colors.white10),
              Expanded(
                flex: 3,
                child: _buildMainArea(state, settings),
              ),
              if (state.activeUtility != UtilityModule.none || state.activeSubUtility != SubUtilityModule.none) ...[
                const VerticalDivider(width: 1, color: Colors.white10),
                Expanded(
                  flex: 1,
                  child: _buildUtilityArea(state, ctrl, settings),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, WorkbenchState state, WorkbenchCtrl ctrl, SettingsState settings) {
    return Container(
      width: 250,
      color: Colors.black.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebarHeader(context),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildSectionHeader("PRIMARY AUDITORIUMS"),
                ...MainModule.values.map(
                  (m) => _buildModuleTile(
                    m.getTitle(settings.isThematicNames),
                    isSelected: state.activeMain == m,
                    onTap: () => ctrl.selectMain(m),
                    color: _getMainColor(m),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader("SIDE UTILITIES"),
                ...UtilityModule.values
                    .where((m) => m != UtilityModule.none)
                    .map(
                      (m) => _buildModuleTile(
                      m.getTitle(settings.isThematicNames),
                      isSelected: state.activeUtility == m,
                      onTap: () => ctrl.selectUtility(m),
                      color: _getUtilityColor(m),
                    ),
                    ),
                const SizedBox(height: 32),
                _buildSectionHeader("AUXILIARY SYSTEMS"),
                ...SubUtilityModule.values
                    .where((m) => m != SubUtilityModule.none)
                    .map(
                      (m) => _buildModuleTile(
                      m.getTitle(settings.isThematicNames),
                      isSelected: state.activeSubUtility == m,
                      onTap: () => ctrl.selectSubUtility(m),
                      color: Colors.cyanAccent,
                    ),
                    ),
              ],
            ),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white24, size: 18),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              Text(
                "INTEGRATED AUDIT",
                style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, letterSpacing: 1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Text(
              "TERMINAL WRK-01",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.shareTechMono(color: Colors.white10, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModuleTile(String title, {required bool isSelected, required VoidCallback onTap, required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: isSelected ? color : Colors.transparent, width: 3)),
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Text(
          title,
          style: GoogleFonts.shareTechMono(
            color: isSelected ? color : Colors.white38,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMainArea(WorkbenchState state, SettingsState settings) {
    return Column(
      children: [
        _buildModuleHeader(state.activeMain.getTitle(settings.isThematicNames), _getMainColor(state.activeMain)),
        Expanded(
          child: _getMainView(state.activeMain),
        ),
      ],
    );
  }

  Widget _buildUtilityArea(WorkbenchState state, WorkbenchCtrl ctrl, SettingsState settings) {
    final hasSub = state.activeSubUtility != SubUtilityModule.none;
    final hasMain = state.activeUtility != UtilityModule.none;

    return Column(
      children: [
        if (hasMain)
          Expanded(
            flex: hasSub ? 1 : 2,
            child: Column(
              children: [
                _buildModuleHeader(
                  state.activeUtility.getTitle(settings.isThematicNames),
                  _getUtilityColor(state.activeUtility),
                  onClear: () => ctrl.selectUtility(UtilityModule.none),
                ),
                Expanded(
                  child: _getUtilityView(state.activeUtility),
                ),
              ],
            ),
          ),
        if (hasSub) ...[
          if (hasMain) const Divider(height: 1, color: Colors.white10),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildModuleHeader(
                  state.activeSubUtility.getTitle(settings.isThematicNames),
                  Colors.cyanAccent,
                  onClear: () => ctrl.selectSubUtility(SubUtilityModule.none),
                ),
                Expanded(
                  child: _getSubUtilityView(state.activeSubUtility),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModuleHeader(String title, Color color, {VoidCallback? onClear}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.2), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.ebGaramond(color: color, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          if (onClear != null)
            IconButton(
              onPressed: onClear,
              icon: Icon(Icons.close, color: color.withValues(alpha: 0.3), size: 14),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Widget _getMainView(MainModule module) {
    switch (module) {
      case MainModule.algebra:
        return const AlgebraView();
      case MainModule.triangle:
        return const TriangleView();
      case MainModule.pythagorean:
        return const PythagoreanView();
      case MainModule.gridPythagorean:
        return const GridPythagoreanView();
    }
  }

  Widget _getUtilityView(UtilityModule module) {
    switch (module) {
      case UtilityModule.radical:
        return const RadicalView(isCompact: true);
      case UtilityModule.fraction:
        return const Center(
          child: Text("FRACTION UNIT OFFLINE", style: TextStyle(color: Colors.white24)),
        );
      case UtilityModule.calculator:
        return const MiniCalculatorView();
      case UtilityModule.reflection:
        return const ReflectionView(isCompact: true);
      case UtilityModule.rotation:
        return const RotationView(isCompact: true);
      case UtilityModule.transformationSequence:
        return const TransformationSequenceView(isCompact: true);
      case UtilityModule.none:
        return const SizedBox.shrink();
    }
  }

  Widget _getSubUtilityView(SubUtilityModule module) {
    switch (module) {
      case SubUtilityModule.notepad:
        return const NotepadView();
      case SubUtilityModule.calculator:
        return const MiniCalculatorView();
      case SubUtilityModule.none:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSidebarFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        "BUREAU SYSTEMS OS v4.2\nAUTH: SYLVESTER AUDIT",
        style: GoogleFonts.shareTechMono(color: Colors.white10, fontSize: 8),
      ),
    );
  }

  Color _getMainColor(MainModule module) {
    switch (module) {
      case MainModule.algebra:
        return Colors.greenAccent;
      case MainModule.triangle:
        return Colors.greenAccent;
      case MainModule.pythagorean:
        return Colors.blueAccent;
      case MainModule.gridPythagorean:
        return Colors.cyanAccent;
    }
  }

  Color _getUtilityColor(UtilityModule module) {
    switch (module) {
      case UtilityModule.radical:
        return Colors.purpleAccent;
      case UtilityModule.fraction:
        return Colors.orangeAccent;
      case UtilityModule.calculator:
        return Colors.cyanAccent;
      case UtilityModule.reflection:
        return Colors.orangeAccent;
      case UtilityModule.rotation:
        return Colors.redAccent;
      case UtilityModule.transformationSequence:
        return Colors.blueAccent;
      case UtilityModule.none:
        return Colors.white24;
    }
  }
}
