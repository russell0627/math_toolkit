import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/elements_ctrl.dart';
import '../models/element_model.dart';
import 'widgets/element_cell.dart';

class ElementalRegistryScreen extends ConsumerWidget {
  const ElementalRegistryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(elementsCtrlProvider);
    final ctrl = ref.read(elementsCtrlProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "SUBSTANCE AUDIT: ELEMENTAL REGISTRY",
          style: GoogleFonts.cutiveMono(
            color: Colors.white24,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white10, size: 18),
            onPressed: () => _showAccuracyProtocol(),
            tooltip: "DATA ACCURACY PROTOCOL",
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(ctrl),
          const Divider(color: Colors.white10, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1000, // Fixed width for the 18-column grid
                  child: Stack(
                    children: [
                      _buildPeriodicGrid(state, ctrl),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildStatusFooter(state),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ElementsCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.black12,
      child: TextField(
        onChanged: ctrl.setSearchQuery,
        style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white24, size: 16),
          hintText: "SEARCH ELEMENT BY SYMBOL, NAME, OR ATOMIC NUMBER...",
          hintStyle: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 10),
          isDense: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPeriodicGrid(ElementsState state, ElementsCtrl ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 18,
          childAspectRatio: 1,
        ),
        itemCount: 18 * 10, // 10 rows
        itemBuilder: (context, index) {
          final x = (index % 18) + 1;
          final y = (index ~/ 18) + 1;

          // Find if an element exists at this x,y
          final element = state.allElements.where((e) => e.x == x && e.y == y).firstOrNull;

          if (element == null) return const SizedBox();

          // Check if it passes search filter
          final isFiltered = state.filteredElements.contains(element);

          return Opacity(
            opacity: isFiltered ? 1.0 : 0.1,
            child: ElementCell(
              element: element,
              isSelected: state.selectedElement == element,
              onTap: () => _showSubstanceDossier(element),
            ),
          );
        },
      ),
    );
  }

  void _showSubstanceDossier(BureauElement element) {
    SmartDialog.show(
      builder: (_) => _SubstanceDossierOverlay(element: element),
      alignment: Alignment.center,
      maskColor: Colors.black87,
    );
  }

  void _showAccuracyProtocol() {
    SmartDialog.show(
      builder: (_) => Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DATA ACCURACY PROTOCOL [V.99-A]",
              style: GoogleFonts.cutiveMono(color: Colors.amberAccent, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.white10, height: 24),
            Text(
              "All atomic statistics provided within the Elemental Registry are sourced from standardized NIST (National Institute of Standards and Technology) and IUPAC datasets. The Bureau ensures zero-latency data integrity through strictly compiled local registries.",
              style: GoogleFonts.cutiveMono(color: Colors.white70, fontSize: 12, height: 1.5),
            ),
            const SizedBox(height: 20),
            Text(
              "VERIFICATION STATUS: AUTHORIZED",
              style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 10),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => SmartDialog.dismiss(),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24)),
                child: Text("CONFIRM INTEGRITY", style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFooter(ElementsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: Colors.black26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "INDEXED ELEMENTS: ${state.allElements.length}/118",
            style: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 8),
          ),
          Text(
            "REGISTRY STATUS: READ_ONLY",
            style: GoogleFonts.cutiveMono(color: Colors.white10, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _SubstanceDossierOverlay extends StatelessWidget {
  final BureauElement element;
  const _SubstanceDossierOverlay({required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: Colors.white10, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BUREAU DOSSIER", style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8)),
                  Text(
                    element.name.toUpperCase(),
                    style: GoogleFonts.ebGaramond(
                      color: Colors.amberAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  element.symbol,
                  style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 32),
          _buildInfoRow("ATOMIC NUMBER", element.atomicNumber.toString()),
          _buildInfoRow("ATOMIC MASS", "${element.atomicMass} u"),
          _buildInfoRow("CATEGORY", element.category.toUpperCase()),
          _buildInfoRow("CONFIG", element.electronConfiguration),
          const SizedBox(height: 16),
          Text("APPEARANCE DESCRIPTION", style: GoogleFonts.cutiveMono(color: Colors.white24, fontSize: 8)),
          const SizedBox(height: 4),
          Text(
            element.appearance,
            style: GoogleFonts.cutiveMono(color: Colors.white70, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => SmartDialog.dismiss(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text("CLOSE DOSSIER", style: GoogleFonts.cutiveMono(color: Colors.white, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.cutiveMono(color: Colors.white38, fontSize: 10)),
          Text(
            value,
            style: GoogleFonts.cutiveMono(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
