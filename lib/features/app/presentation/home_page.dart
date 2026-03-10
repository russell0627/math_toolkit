import 'package:awesome_flutter_extensions/awesome_flutter_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../routes.dart';
import '../../../../utils/screen_utils.dart';
import '../../settings/presentation/bureau_settings_dialog.dart';
import '../services/app/app_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appServiceProvider.select((state) => state.appVersion));
    final styles = context.textStyles;

    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "BUREAU MATH TOOLS",
          style: GoogleFonts.ebGaramond(
            textStyle: styles.titleMedium.copyWith(
              color: Colors.amberAccent,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => BureauSettingsDialog.show(),
            icon: const Icon(Icons.settings, color: Colors.white24),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: paddingAllM,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AUTHORIZED UTILITIES ONLY",
                style: GoogleFonts.ebGaramond(
                  textStyle: styles.labelSmall.copyWith(
                    color: Colors.white38,
                    letterSpacing: 2,
                  ),
                ),
              ),
              boxM,
              Expanded(
                child: ListView(
                  children: [
                    _buildSectionHeader("INTEGRATED ENVIRONMENTS", Colors.deepOrangeAccent),
                    _MenuCard(
                      title: "AUDIT WORKBENCH",
                      subtitle: "MULTI-MODULE TERMINAL (WRK-01)",
                      icon: Icons.dashboard_customize_outlined,
                      accentColor: Colors.deepOrangeAccent,
                      onTap: () => context.pushNamed(AppRoute.workbench.name),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader("CORE MATHEMATICS", Colors.amberAccent),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _MenuCard(
                          title: "CALCULATOR",
                          subtitle: "BASIC ARITHMETIC UNIT",
                          icon: Icons.calculate_outlined,
                          accentColor: Colors.amberAccent,
                          onTap: () => context.pushNamed(AppRoute.calculator.name),
                        ),
                        _MenuCard(
                          title: "ALGEBRA",
                          subtitle: "EQUATION ALIGNMENT UNIT",
                          icon: Icons.functions_outlined,
                          accentColor: Colors.amberAccent,
                          onTap: () => context.pushNamed(AppRoute.algebra.name),
                        ),
                        _MenuCard(
                          title: "GEOMETRY",
                          subtitle: "GEOMETRIC ALIGNMENT (TRI-01)",
                          icon: Icons.change_history,
                          accentColor: Colors.amberAccent,
                          onTap: () => context.pushNamed(AppRoute.triangleSolver.name),
                        ),
                        _MenuCard(
                          title: "PYTHAGOREAN",
                          subtitle: "HYPOTENUSE VERIFICATION (PYT-02)",
                          icon: Icons.square_foot,
                          accentColor: Colors.amberAccent,
                          onTap: () => context.pushNamed(AppRoute.pythagorean.name),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader("DATA SURVEILLANCE", Colors.greenAccent),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _MenuCard(
                          title: "INDEXING",
                          subtitle: "PRIME-NUMBER SIEVE",
                          icon: Icons.grid_view,
                          accentColor: Colors.greenAccent,
                          onTap: () => context.pushNamed(AppRoute.primeSieve.name),
                        ),
                        _MenuCard(
                          title: "SURVEILLANCE",
                          subtitle: "SIGNAL AUDITOR UNIT",
                          icon: Icons.radar,
                          accentColor: Colors.greenAccent,
                          onTap: () => context.pushNamed(AppRoute.signalAuditor.name),
                        ),
                        _MenuCard(
                          title: "OBSERVATION",
                          subtitle: "MATHEMATICAL PI-STREAM",
                          icon: Icons.data_usage,
                          accentColor: Colors.greenAccent,
                          onTap: () => context.pushNamed(AppRoute.piStream.name),
                        ),
                        _MenuCard(
                          title: "Minesweeper",
                          subtitle: "SUB-SURFACE SCANNER",
                          icon: Icons.grid_on,
                          accentColor: Colors.greenAccent,
                          onTap: () => context.pushNamed(AppRoute.minesweeper.name),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader("BUREAU UTILITIES", Colors.blueAccent),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _MenuCard(
                          title: "FRACTION",
                          subtitle: "RATIO REDUCTION UNIT",
                          icon: Icons.rebase_edit,
                          accentColor: Colors.blueAccent,
                          onTap: () => context.pushNamed(AppRoute.fractionSimplifier.name),
                        ),
                        _MenuCard(
                          title: "AUDIT",
                          subtitle: "FISCAL STATISTICS UNIT",
                          icon: Icons.analytics_outlined,
                          accentColor: Colors.blueAccent,
                          onTap: () => context.pushNamed(AppRoute.budgetAudit.name),
                        ),
                        _MenuCard(
                          title: "CIPHER",
                          subtitle: "SECURITY ENCRYPTION UNIT",
                          icon: Icons.security_outlined,
                          accentColor: Colors.blueAccent,
                          onTap: () => context.pushNamed(AppRoute.cipher.name),
                        ),
                        _MenuCard(
                          title: "SUBSTANCE",
                          subtitle: "ELEMENTAL REGISTRY UNIT",
                          icon: Icons.science_outlined,
                          accentColor: Colors.blueAccent,
                          onTap: () => context.pushNamed(AppRoute.elementalRegistry.name),
                        ),
                        _MenuCard(
                          title: "RADICAL",
                          subtitle: "RADICAL REDUCTION UNIT (RAD-03)",
                          icon: Icons.square_foot,
                          accentColor: Colors.purpleAccent,
                          onTap: () => context.pushNamed(AppRoute.radicalSimplifier.name),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  "UNIT ID: SN-BUREAU-V$appVersion",
                  style: GoogleFonts.cutiveMono(
                    textStyle: styles.labelSmall.copyWith(color: Colors.white10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Row(
        children: [
          Container(width: 4, height: 12, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.cutiveMono(
              color: color.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(color: color.withValues(alpha: 0.1))),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: accentColor.withValues(alpha: 0.8)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.cutiveMono(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.cutiveMono(
                color: accentColor.withValues(alpha: 0.4),
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
