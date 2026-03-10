import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../algebra/presentation/algebra_view.dart';
import '../../fraction_simplifier/presentation/fraction_simplifier_view.dart';
import '../../grid_pythagorean/presentation/grid_pythagorean_view.dart';
import '../../pythagorean/presentation/pythagorean_view.dart';
import '../../radical_simplifier/presentation/radical_view.dart';
import '../../reflection_mapper/presentation/reflection_view.dart';
import '../../rotation_mapper/presentation/rotation_view.dart';
import '../../settings/controller/settings_ctrl.dart';
import '../../transformation_sequence/presentation/transformation_sequence_view.dart';
import '../../triangle_solver/presentation/triangle_view.dart';
import '../controller/workbench_ctrl.dart';
import '../model/workbench_model.dart';

class WorkbenchScreen extends ConsumerWidget {
  const WorkbenchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workbenchState = ref.watch(workbenchCtrlProvider);
    final activeMain = workbenchState.activeMain;
    final activeUtility = workbenchState.activeUtility;
    final settings = ref.watch(settingsCtrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Row(
        children: [
          _buildSidebar(context, ref, activeMain, activeUtility, settings),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMainArea(context, ref, activeMain, settings),
                ),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                Expanded(
                  flex: 2,
                  child: _buildUtilityArea(context, ref, activeUtility, settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    WidgetRef ref,
    MainModule activeMain,
    UtilityModule activeUtility,
    SettingsState settings,
  ) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSidebarHeader(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text("CORE MODULES", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.2)),
          ),
          ...MainModule.values.map((module) => _buildModuleTile(
                module.title(useBureau: settings.useBureauNaming),
                module == activeMain,
                () => ref.read(workbenchCtrlProvider.notifier).selectMain(module),
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
            child: Text("UTILITIES", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.2)),
          ),
          ...UtilityModule.values.where((m) => m != UtilityModule.none).map((module) => _buildModuleTile(
                module.title(useBureau: settings.useBureauNaming),
                module == activeUtility,
                () => ref.read(workbenchCtrlProvider.notifier).selectUtility(module),
              )),
          const Spacer(),
          _buildSidebarFooter(ref, settings),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("SYLVESTER", style: GoogleFonts.oswald(color: Colors.amberAccent, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
          Text("MATH TOOLS V4.1", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSidebarFooter(WidgetRef ref, SettingsState settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings, size: 14, color: Colors.white38),
              const SizedBox(width: 8),
              Text(
                "SETTINGS",
                style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => ref.read(settingsCtrlProvider.notifier).toggleBureauNaming(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "THEMATIC NAMING",
                  style: GoogleFonts.shareTechMono(
                    color: settings.useBureauNaming ? Colors.amberAccent : Colors.white24,
                    fontSize: 9,
                  ),
                ),
                Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    value: settings.useBureauNaming,
                    onChanged: (_) => ref.read(settingsCtrlProvider.notifier).toggleBureauNaming(),
                    activeThumbColor: Colors.amberAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleTile(String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: isActive ? const Border(left: BorderSide(color: Colors.amberAccent, width: 2)) : null,
          color: isActive ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Text(
          label,
          style: GoogleFonts.shareTechMono(
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildMainArea(BuildContext context, WidgetRef ref, MainModule active, SettingsState settings) {
    return Column(
      children: [
        _buildAreaHeader(active.title(useBureau: settings.useBureauNaming), Colors.amberAccent),
        Expanded(
          child: switch (active) {
            MainModule.pythagorean => const PythagoreanView(),
            MainModule.gridPythagorean => const GridPythagoreanView(),
            MainModule.triangle => const TriangleView(),
            MainModule.algebra => const AlgebraView(),
          },
        ),
      ],
    );
  }

  Widget _buildUtilityArea(BuildContext context, WidgetRef ref, UtilityModule active, SettingsState settings) {
    return Column(
      children: [
        _buildAreaHeader(active.title(useBureau: settings.useBureauNaming), Colors.blueAccent),
        Expanded(
          child: switch (active) {
            UtilityModule.radical => const RadicalView(isCompact: true),
            UtilityModule.fraction => const FractionSimplifierView(isCompact: true),
            UtilityModule.calculator => const Center(child: Text("CALC", style: TextStyle(color: Colors.white24))),
            UtilityModule.reflection => const ReflectionView(isCompact: true),
            UtilityModule.rotation => const RotationView(isCompact: true),
            UtilityModule.transformationSequence => const TransformationSequenceView(isCompact: true),
            UtilityModule.none => const Center(child: Icon(Icons.analytics_outlined, color: Colors.white10, size: 64)),
          },
        ),
      ],
    );
  }

  Widget _buildAreaHeader(String title, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}
