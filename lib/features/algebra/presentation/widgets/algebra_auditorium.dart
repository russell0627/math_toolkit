import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/presentation/widgets/bureau_balance_scale.dart';
import '../../../app/presentation/widgets/bureau_complexity_gauge.dart';
import '../../../app/presentation/widgets/bureau_rotary_selector.dart';
import '../../../app/presentation/widgets/bureau_stamp.dart';
import '../../../app/presentation/widgets/bureau_toggle.dart';
import '../../../keypad/tactile_keypad_button.dart';
import '../../../settings/controller/settings_ctrl.dart';
import '../../../settings/presentation/bureau_settings_dialog.dart';
import '../../controller/algebra_ctrl.dart';
import 'suggestion_chips.dart';

class AlgebraAuditorium extends ConsumerStatefulWidget {
  final bool isCompact;
  const AlgebraAuditorium({super.key, this.isCompact = false});

  @override
  ConsumerState<AlgebraAuditorium> createState() => _AlgebraAuditoriumState();
}

class _AlgebraAuditoriumState extends ConsumerState<AlgebraAuditorium> with TickerProviderStateMixin {
  final TextEditingController _leftController = TextEditingController();
  final TextEditingController _rightController = TextEditingController();
  final TextEditingController _fullEquationController = TextEditingController();
  final TextEditingController _opValueController = TextEditingController();

  final FocusNode _fullFocusNode = FocusNode();
  final FocusNode _leftFocusNode = FocusNode();
  final FocusNode _rightFocusNode = FocusNode();
  final FocusNode _opFocusNode = FocusNode();

  String _selectedOp = '+';
  bool _isDrawerOpen = false;
  bool _isRegistryOpen = false;

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    _fullEquationController.dispose();
    _opValueController.dispose();
    _fullFocusNode.dispose();
    _leftFocusNode.dispose();
    _rightFocusNode.dispose();
    _opFocusNode.dispose();
    super.dispose();
  }

  void _initializeEquation() {
    final full = _fullEquationController.text.trim();
    if (full.isNotEmpty) {
      ref.read(algebraCtrlProvider.notifier).setFullEquation(full);
    } else {
      ref.read(algebraCtrlProvider.notifier).setEquation(_leftController.text, _rightController.text);
    }
  }

  void _applyOp() {
    final val = _opValueController.text.trim();
    if (val == "0000") {
      ref.read(algebraCtrlProvider.notifier).toggleAutoSolve();
      _opValueController.clear();
      return;
    }
    ref.read(algebraCtrlProvider.notifier).applyOperation(_selectedOp, _opValueController.text);
    _opValueController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(algebraCtrlProvider);
    final ctrl = ref.read(algebraCtrlProvider.notifier);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: widget.isCompact ? 16 : 24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    if (state.history.isEmpty && state.leftSide.isEmpty && state.rightSide.isEmpty)
                      _buildInitialization(state, ctrl)
                    else ...[
                      _buildSystemHUD(state, ctrl),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(child: _buildActiveSession(state, ctrl)),
                          if (!widget.isCompact) ...[
                            const SizedBox(width: 8),
                            BureauRotarySelector(
                              itemCount: state.equations.length,
                              selectedIndex: state.selectedIndex,
                              onSelected: (idx) => ctrl.selectEquation(idx),
                              onAdd: () => ctrl.addEquation(),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAuditLog(state),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Custom Sidebar Overlay (Left/Registry)
        _buildSidebarOverlay(
          isOpen: _isRegistryOpen,
          isRight: false,
          child: _RegistrySidebar(
            state: state,
            ctrl: ctrl,
            onClose: () => setState(() => _isRegistryOpen = false),
            onRename: (oldName) => _showRenameDialog(oldName, ctrl),
            onSelectValue: (val) {
              _opValueController.text = val;
              setState(() => _isRegistryOpen = false);
            },
          ),
        ),

        // Custom Sidebar Overlay (Right/Drawer)
        _buildSidebarOverlay(
          isOpen: _isDrawerOpen,
          isRight: true,
          child: _AlgebraDrawer(
            ctrl: ctrl,
            ref: ref,
            showScratchpad: () => _showScratchpad(context),
            onClose: () => setState(() => _isDrawerOpen = false),
          ),
        ),

        // Tactical Handles
        if (true) ...[
          // Left Handle (Registry)
          Positioned(
            left: 0,
            top: MediaQuery.of(context).size.height / 2 - 60,
            child: _TacticalHandle(
              isRight: false,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _isRegistryOpen = !_isRegistryOpen;
                  _isDrawerOpen = false;
                });
              },
            ),
          ),
          // Right Handle (Operational Hub)
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height / 2 - 60,
            child: _TacticalHandle(
              isRight: true,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                  _isRegistryOpen = false;
                });
              },
            ),
          ),
        ],

        if (state.showAuditStamp)
          BureauStamp(
            type: StampType.authenticated,
            onComplete: () => ctrl.clearStamp(),
          ),
      ],
    );
  }

  Widget _buildSidebarOverlay({required bool isOpen, required bool isRight, required Widget child}) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: isRight ? null : (isOpen ? 0 : -300),
      right: isRight ? (isOpen ? 0 : -300) : null,
      top: 0,
      bottom: 0,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          boxShadow: [
            if (isOpen)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
          ],
          border: Border(
            left: isRight ? const BorderSide(color: Colors.white10) : BorderSide.none,
            right: !isRight ? const BorderSide(color: Colors.white10) : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }

  void _showScratchpad(BuildContext context) {
    // Ported from AlgebraScreen
    SmartDialog.show(
      builder: (_) => Container(
        width: 600,
        height: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          children: [
            Text("SCRATCHPAD PROTOCOL", style: GoogleFonts.shareTechMono(color: Colors.amberAccent)),
            const Spacer(),
            Text("NOT IMPLEMENTED IN THIS BUILD", style: GoogleFonts.shareTechMono(color: Colors.white24)),
            const Spacer(),
            TextButton(onPressed: () => SmartDialog.dismiss(), child: const Text("CLOSE")),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialization(AlgebraState state, AlgebraCtrl ctrl) {
    final settings = ref.watch(settingsCtrlProvider);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(
                "INPUT INITIAL EQUATION",
                style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10),
              ),
              const SizedBox(height: 20),
              if (!settings.isSplitEntryMode)
                TextField(
                  controller: _fullEquationController,
                  focusNode: _fullFocusNode,
                  style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "UNIFIED ENTRY (e.g. 2x + 5 = 15)",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.linear_scale, color: Colors.greenAccent, size: 16),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.keyboard, color: Colors.amberAccent),
                      onPressed: () => _showKeypadDialog(_fullEquationController),
                    ),
                  ),
                  onSubmitted: (_) => _initializeEquation(),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _leftController,
                        focusNode: _leftFocusNode,
                        style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "LHS",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.keyboard, color: Colors.amberAccent, size: 16),
                            onPressed: () => _showKeypadDialog(_leftController),
                          ),
                        ),
                        onSubmitted: (_) => _initializeEquation(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("=", style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 24)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _rightController,
                        focusNode: _rightFocusNode,
                        style: GoogleFonts.shareTechMono(color: Colors.greenAccent, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "RHS",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.keyboard, color: Colors.amberAccent, size: 16),
                            onPressed: () => _showKeypadDialog(_rightController),
                          ),
                        ),
                        onSubmitted: (_) => _initializeEquation(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _initializeEquation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("ESTABLISH BASELINE"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _showStencilPicker(context, ctrl),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.amberAccent),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Text("PROCURE PROTOCOL STENCIL", style: GoogleFonts.shareTechMono(color: Colors.amberAccent)),
        ),
      ],
    );
  }

  Widget _buildActiveSession(AlgebraState state, AlgebraCtrl ctrl) {
    final currentEq = state.equations[state.selectedIndex];
    final leftWeight = currentEq.left.split(RegExp(r'[+-]')).where((t) => t.trim().isNotEmpty).length.toDouble();
    final rightWeight = currentEq.right.split(RegExp(r'[+-]')).where((t) => t.trim().isNotEmpty).length.toDouble();

    return Column(
      children: [
        BureauBalanceScale(leftWeight: leftWeight, rightWeight: rightWeight),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF050F05),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    "SYSTEM STATE",
                    style: GoogleFonts.shareTechMono(color: Colors.greenAccent.withValues(alpha: 0.5), fontSize: 10),
                  ),
                  const SizedBox(height: 16),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDropZone(currentEq.left, 'LHS', state, ctrl, leftWeight),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            currentEq.relation,
                            style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 28),
                          ),
                        ),
                        _buildDropZone(currentEq.right, 'RHS', state, ctrl, rightWeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildOperationConsole(state, ctrl),
      ],
    );
  }

  Widget _buildDropZone(String raw, String side, AlgebraState state, AlgebraCtrl ctrl, double weight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BureauComplexityGauge(complexity: (weight / 10).clamp(0.0, 1.0), size: 16),
            const SizedBox(width: 4),
            Text(side, style: GoogleFonts.shareTechMono(color: Colors.greenAccent.withValues(alpha: 0.3), fontSize: 8)),
            const SizedBox(width: 4),
            InkWell(
              onTap: () => ctrl.simplifySide(side == 'LHS'),
              child: Icon(Icons.auto_fix_high, size: 10, color: Colors.blueAccent.withValues(alpha: 0.5)),
            ),
          ],
        ),
        DragTarget<String>(
          onAcceptWithDetails: (details) {
            if (details.data.startsWith('TERM:')) {
              final term = details.data.replaceFirst('TERM:', '');
              ctrl.moveTerm(term, side == 'LHS' ? 'RHS' : 'LHS', side);
            } else {
              ctrl.applyOperation(_selectedOp, details.data);
            }
          },
          builder: (context, candidateData, rejectedData) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: candidateData.isNotEmpty ? Colors.amberAccent : Colors.transparent),
            ),
            child: _buildInteractiveEquation(raw, side, ctrl),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveEquation(String raw, String side, AlgebraCtrl ctrl) {
    if (raw.isEmpty) return Text("0", style: GoogleFonts.shareTechMono(color: Colors.white10, fontSize: 32));

    final terms = <String>[];
    String currentTerm = "";
    int depth = 0;
    String normalized = raw.replaceAll(' ', '');

    for (int i = 0; i < normalized.length; i++) {
      final char = normalized[i];
      if (char == '(') depth++;
      if (char == ')') depth--;
      if (depth == 0 && i > 0 && (char == '+' || char == '-')) {
        if (currentTerm.isNotEmpty) terms.add(currentTerm);
        currentTerm = char;
      } else {
        currentTerm += char;
      }
    }
    if (currentTerm.isNotEmpty) terms.add(currentTerm);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: terms.map((term) {
        final displayTerm = term.replaceAll('sqrt(', '√(');
        return Draggable<String>(
          data: 'TERM:$term',
          feedback: Material(
            color: Colors.transparent,
            child: Text(
              displayTerm,
              style: GoogleFonts.shareTechMono(color: Colors.amberAccent.withValues(alpha: 0.5), fontSize: 24),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.2,
            child: Text(displayTerm, style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 32)),
          ),
          child: InkWell(
            onTap: () => _handleTermTap(term, side, ctrl),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                displayTerm,
                style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _handleTermTap(String term, String side, AlgebraCtrl ctrl) {
    // Ported from AlgebraScreen
    String suggestedOp = "";
    String suggestedVal = "";

    if (term.startsWith('+')) {
      suggestedOp = '-';
      suggestedVal = term.substring(1);
    } else if (term.startsWith('-')) {
      suggestedOp = '+';
      suggestedVal = term.substring(1);
    } else {
      // For terms at the start without sign
      suggestedOp = '-';
      suggestedVal = term;
    }

    if (ref.read(settingsCtrlProvider).isAutoApplyMode) {
      ctrl.applyOperation(suggestedOp, suggestedVal);
    } else {
      setState(() {
        _selectedOp = suggestedOp;
        _opValueController.text = suggestedVal;
      });
    }
  }

  Widget _buildOperationConsole(AlgebraState state, AlgebraCtrl ctrl) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SuggestionChips(),
          const SizedBox(height: 16),
          Text("APPLY OPERATION TO NODE", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildOpSelector(),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _opValueController,
                  focusNode: _opFocusNode,
                  style: GoogleFonts.shareTechMono(color: Colors.amberAccent),
                  decoration: InputDecoration(
                    hintText: "VALUE",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.keyboard, color: Colors.amberAccent, size: 14),
                      onPressed: () => _showKeypadDialog(_opValueController),
                    ),
                  ),
                  onSubmitted: (_) => _applyOp(),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                onPressed: () => ctrl.manualSimplify(),
                icon: const Icon(Icons.auto_fix_high, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _applyOp,
                icon: const Icon(Icons.play_arrow),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
          if (ref.watch(settingsCtrlProvider).isAutoSolveEnabled) ...[
            const SizedBox(height: 16),
            if (state.multiSelectIndices.length == 2) ...[
              _SystemAnalysisButton(onPressed: () => ctrl.solveSystem()),
              const SizedBox(height: 12),
            ],
            _UnsanctionedSolveButton(onPressed: () => ctrl.solve()),
            const SizedBox(height: 12),
            _SymbolicActionButton(
              label: "EXECUTE CROSS-MULTIPLICATION PROTOCOL",
              icon: Icons.unfold_more,
              onPressed: () => ctrl.crossMultiply(),
            ),
            const SizedBox(height: 12),
            _CentralizationButton(onPressed: () => ctrl.centralize()),
            const SizedBox(height: 12),
            _SymbolicActionButton(
              label: "APPLY SYMBOLIC EXPANSION PASS",
              icon: Icons.unfold_more,
              onPressed: () => ctrl.symbolicExpand(),
            ),
            const SizedBox(height: 12),
            _SymbolicActionButton(
              label: "APPLY SQUARE ROOT PROTOCOL",
              icon: Icons.auto_awesome,
              onPressed: () => ctrl.applyOperation("SQRT", ""),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuditLog(AlgebraState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AUDIT LOG (HISTORY)", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.history.length,
          itemBuilder: (context, index) {
            final histState = state.history[index];
            final isLast = index == state.history.length - 1;
            final histEq = histState.equations[histState.selectedIndex];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isLast ? Colors.greenAccent.withValues(alpha: 0.05) : Colors.transparent,
                border: Border.all(color: isLast ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.white10),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Text(
                    "#${index.toString().padLeft(2, '0')}",
                    style: GoogleFonts.shareTechMono(color: Colors.white10, fontSize: 10),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${histEq.left} ${histEq.relation} ${histEq.right}",
                      style: GoogleFonts.shareTechMono(
                        color: isLast ? Colors.greenAccent : Colors.white24,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (histState.lastOp != null)
                    Text(
                      "[ ${histState.lastOp} ]",
                      style: GoogleFonts.shareTechMono(color: Colors.amberAccent.withValues(alpha: 0.5), fontSize: 10),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSystemHUD(AlgebraState state, AlgebraCtrl ctrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => setState(() {
            _isDrawerOpen = !_isDrawerOpen;
            _isRegistryOpen = false;
          }),
          icon: Icon(Icons.menu, color: _isDrawerOpen ? Colors.amberAccent : Colors.white24, size: 18),
          tooltip: "OPERATIONAL HUB",
        ),
        IconButton(
          onPressed: () => setState(() {
            _isRegistryOpen = !_isRegistryOpen;
            _isDrawerOpen = false;
          }),
          icon: Icon(Icons.assessment_outlined, color: _isRegistryOpen ? Colors.amberAccent : Colors.white24, size: 18),
          tooltip: "VARIABLE REGISTRY",
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => ctrl.swapSides(),
          icon: const Icon(Icons.sync_alt, color: Colors.amberAccent, size: 18),
          tooltip: "SYMMETRY PROTOCOL",
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => BureauSettingsDialog.show(),
          icon: const Icon(Icons.tune, color: Colors.white38, size: 18),
          tooltip: "SYSTEM CONFIG",
        ),
      ],
    );
  }

  Widget _buildOpSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: _selectedOp,
        dropdownColor: const Color(0xFF222222),
        underline: const SizedBox(),
        items: ['+', '-', '*', '/', 'SQRT'].map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: GoogleFonts.shareTechMono(color: Colors.amberAccent)),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedOp = val);
        },
      ),
    );
  }

  void _showKeypadDialog(TextEditingController controller) {
    SmartDialog.show(
      builder: (_) => Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.3), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("INPUT TERMINAL", style: GoogleFonts.shareTechMono(color: Colors.amberAccent, fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white24, size: 18),
                    onPressed: () => SmartDialog.dismiss(),
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              _AlgebraEntryKeypad(
                onTap: (text) {
                  if (text == "BACKSPACE") {
                    final txt = controller.text;
                    if (txt.isNotEmpty) controller.text = txt.substring(0, txt.length - 1);
                  } else {
                    controller.text += text;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(String oldName, AlgebraCtrl ctrl) {
    final controller = TextEditingController(text: oldName);
    SmartDialog.show(
      builder: (_) => Container(
        width: 280,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("REFACTOR VARIABLE", style: GoogleFonts.shareTechMono(color: Colors.amberAccent)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: GoogleFonts.shareTechMono(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => SmartDialog.dismiss(), child: const Text("ABORT")),
                ElevatedButton(
                  onPressed: () {
                    ctrl.renameVariable(oldName, controller.text);
                    SmartDialog.dismiss();
                  },
                  child: const Text("APPLY"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStencilPicker(BuildContext context, AlgebraCtrl ctrl) {
    SmartDialog.show(
      builder: (_) => Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white10, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "STENCIL PROCUREMENT",
              style: GoogleFonts.ebGaramond(
                color: Colors.amberAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              "SELECT FORM FOR PROTOCOL INJECTION",
              style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 8),
            ),
            const SizedBox(height: 20),
            _buildStencilOption(ctrl, "LINEAR ALIGNMENT (1-A)", "x + 5 = 10", "x + 5", "10"),
            _buildStencilOption(ctrl, "PROPORTIONAL BIAS (1-P)", "2x = 24", "2x", "24"),
            _buildStencilOption(ctrl, "QUADRATIC BASE (2-Q)", "x^2 = 16", "x^2", "16"),
            _buildStencilOption(ctrl, "SLOPE-INTERCEPT (1-S)", "y = 2x + 4", "y", "2x + 4"),
            _buildStencilOption(ctrl, "INDUSTRIAL AUDIT (3-A)", "15x - 10 + 5x = 40 + 5x", "15x - 10 + 5x", "40 + 5x"),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => SmartDialog.dismiss(), child: const Text("ABORT")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStencilOption(AlgebraCtrl ctrl, String label, String preview, String left, String right) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12)),
      subtitle: Text(preview, style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 10)),
      onTap: () {
        ctrl.applyStencil(left, right);
        SmartDialog.dismiss();
      },
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white12, size: 12),
    );
  }
}

class _SystemAnalysisButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SystemAnalysisButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withValues(alpha: 0.1),
          border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers_outlined, size: 16, color: Colors.greenAccent),
            const SizedBox(width: 12),
            Text(
              "COMMENCE SYSTEMS ANALYSIS PASS",
              style: GoogleFonts.shareTechMono(
                color: Colors.greenAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SymbolicActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _SymbolicActionButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withValues(alpha: 0.1),
          border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.blueAccent),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.shareTechMono(
                color: Colors.blueAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CentralizationButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CentralizationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.amberAccent.withValues(alpha: 0.1),
          border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.center_focus_strong, size: 16, color: Colors.amberAccent),
            const SizedBox(width: 12),
            Text(
              "TRIGGER VARIABLE CENTRALIZATION",
              style: GoogleFonts.shareTechMono(
                color: Colors.amberAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlgebraDrawer extends StatelessWidget {
  final AlgebraCtrl ctrl;
  final WidgetRef ref;
  final VoidCallback showScratchpad;
  final VoidCallback onClose;

  const _AlgebraDrawer({
    required this.ctrl,
    required this.ref,
    required this.showScratchpad,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsCtrlProvider);
    final settingsCtrl = ref.read(settingsCtrlProvider.notifier);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("OPERATIONAL HUB", style: GoogleFonts.ebGaramond(color: Colors.amberAccent, fontSize: 18)),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white24, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildSectionHeader("OPERATIONAL MODES"),
              _buildToggleTile("RATIONAL MODE", "PROTOCOL-RAT", settings.isRationalMode, (_) {
                settingsCtrl.toggleRationalMode();
                ctrl.refreshAndResolve();
              }),
              _buildToggleTile(
                "RADICAL MODE",
                "PROTOCOL-SURD",
                settings.isRadicalMode,
                (_) {
                  settingsCtrl.toggleRadicalMode();
                  ctrl.refreshAndResolve();
                },
                labelLeft: "DEC",
                labelRight: "SRD",
              ),
              const Divider(color: Colors.white10),
              _buildActionTile("REVERT LAST ACTION", Icons.undo, ctrl.undo),
              _buildActionTile("RESET WORKSPACE", Icons.refresh, ctrl.clear, destructive: true),
              _buildActionTile("OPEN SCRATCHPAD", Icons.calculate_outlined, showScratchpad),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(title, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
    );
  }

  Widget _buildToggleTile(
    String label,
    String code,
    bool value,
    ValueChanged<bool> onChanged, {
    String labelLeft = "DEC",
    String labelRight = "RAT",
  }) {
    return ListTile(
      title: Text(label, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13)),
      trailing: BureauToggle(value: value, onChanged: onChanged, labelLeft: labelLeft, labelRight: labelRight),
    );
  }

  Widget _buildActionTile(String label, IconData icon, VoidCallback onTap, {bool destructive = false}) {
    return ListTile(
      leading: Icon(icon, color: destructive ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white24, size: 20),
      title: Text(
        label,
        style: GoogleFonts.shareTechMono(
          color: destructive ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white70,
          fontSize: 13,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _RegistrySidebar extends StatelessWidget {
  final AlgebraState state;
  final AlgebraCtrl ctrl;
  final VoidCallback onClose;
  final Function(String) onRename;
  final Function(String) onSelectValue;

  const _RegistrySidebar({
    required this.state,
    required this.ctrl,
    required this.onClose,
    required this.onRename,
    required this.onSelectValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("VARIABLE REGISTRY", style: GoogleFonts.ebGaramond(color: Colors.amberAccent, fontSize: 18)),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white24, size: 16),
              ),
            ],
          ),
        ),
        Expanded(
          child: state.resolvedVariables.isEmpty
              ? Center(
                  child: Text("NO RESOLVED NODES", style: GoogleFonts.shareTechMono(color: Colors.white10)),
                )
              : ListView(
                  children: state.resolvedVariables.entries.map((e) {
                    return ListTile(
                      title: Text(e.key, style: GoogleFonts.ebGaramond(color: Colors.amberAccent, fontSize: 20)),
                      trailing: Text(e.value, style: GoogleFonts.shareTechMono(color: Colors.white70)),
                      onTap: () => onSelectValue(e.value),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _TacticalHandle extends StatefulWidget {
  final bool isRight;
  final VoidCallback onTap;
  const _TacticalHandle({required this.isRight, required this.onTap});

  @override
  State<_TacticalHandle> createState() => _TacticalHandleState();
}

class _TacticalHandleState extends State<_TacticalHandle> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.1, end: 0.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final alpha = _pulseAnimation.value;
          return Container(
            width: 12,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.amberAccent.withValues(alpha: alpha),
              borderRadius: widget.isRight
                  ? const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
                  : const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: const Center(child: Icon(Icons.drag_handle, size: 8, color: Colors.amberAccent)),
          );
        },
      ),
    );
  }
}

class _UnsanctionedSolveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _UnsanctionedSolveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 16, color: Colors.redAccent),
            const SizedBox(width: 12),
            Text(
              "ACCESS UNSANCTIONED AUTO-SOLVE",
              style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlgebraEntryKeypad extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _AlgebraEntryKeypad({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3', '+']),
        const SizedBox(height: 12),
        _buildRow(['4', '5', '6', '-']),
        const SizedBox(height: 12),
        _buildRow(['x', '0', '=', 'BACKSPACE']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: keys
          .map(
            (k) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TactileKeypadButton(
                  label: k == 'BACKSPACE' ? "DEL" : k,
                  onTap: () => onTap(k),
                  fontStyle: GoogleFonts.shareTechMono(),
                  isAction: ['+', '-', '=', 'BACKSPACE'].contains(k),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
