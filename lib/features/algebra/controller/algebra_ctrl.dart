import 'dart:math';

import 'package:math_expressions/math_expressions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../settings/controller/settings_ctrl.dart';

part 'algebra_ctrl.g.dart';

@riverpod
class AlgebraCtrl extends _$AlgebraCtrl {
  final Parser _parser = Parser();

  @override
  AlgebraState build() {
    final s = const AlgebraState(
      equations: [EquationPair(left: "", right: "", relation: "=")],
    );
    state = s;
    _updateSuggestions();
    return state;
  }

  void addEquation() {
    final newList = [...state.equations, const EquationPair(left: "", right: "", relation: "=")];
    state = state.copyWith(equations: newList, selectedIndex: newList.length - 1);
    _updateResolvedVariables();
  }

  void duplicateEquation(int index) {
    if (index < 0 || index >= state.equations.length) return;
    final source = state.equations[index];
    final newList = [
      ...state.equations,
      EquationPair(left: source.left, right: source.right, relation: source.relation),
    ];
    state = state.copyWith(equations: newList, selectedIndex: newList.length - 1);
    _updateResolvedVariables();
  }

  void selectEquation(int index) {
    if (index >= 0 && index < state.equations.length) {
      state = state.copyWith(selectedIndex: index);
      _updateSuggestions();
    }
  }

  void removeEquation(int index) {
    if (state.equations.length <= 1) return;
    final newList = List<EquationPair>.from(state.equations)..removeAt(index);
    final newIdx = state.selectedIndex >= newList.length ? newList.length - 1 : state.selectedIndex;
    state = state.copyWith(equations: newList, selectedIndex: newIdx);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  void setFullEquation(String input) {
    if (input.isEmpty) return;

    final relMatch = RegExp(r'<=|>=|<|>|=').firstMatch(input);
    if (relMatch == null) {
      state = state.copyWith(error: "INVALID STATEMENT: NO RELATION DETECTED");
      return;
    }

    final relation = relMatch.group(0)!;
    final parts = input.split(relation);
    if (parts.length != 2) {
      state = state.copyWith(error: "INVALID STATEMENT: MULTIPLE RELATIONS DETECTED");
      return;
    }

    final left = parts[0].trim();
    final right = parts[1].trim();

    if (left.isEmpty || right.isEmpty) {
      state = state.copyWith(error: "INVALID STATEMENT: SIDES CANNOT BE EMPTY");
      return;
    }

    setEquation(left, right, relation: relation);
  }

  void setEquation(String left, String right, {String relation = "="}) {
    try {
      final resolvedLeft = _resolveExpression(left);
      final resolvedRight = _resolveExpression(right);

      final newEq = EquationPair(left: resolvedLeft, right: resolvedRight, relation: relation);
      final newEquations = List<EquationPair>.from(state.equations);
      newEquations[state.selectedIndex] = newEq;

      final newState = state.copyWith(
        equations: newEquations,
      );

      state = newState.copyWith(history: [newState]);
      _updateResolvedVariables();
      _updateSuggestions();
    } catch (e) {
      state = state.copyWith(error: "INVALID EQUATION FORMAT");
    }
  }

  void applyStencil(String left, String right) {
    setEquation(left, right);
  }

  void swapSides() {
    final current = state.equations[state.selectedIndex];
    String nextRelation = current.relation;
    if (nextRelation == "<")
      nextRelation = ">";
    else if (nextRelation == ">")
      nextRelation = "<";
    else if (nextRelation == "<=")
      nextRelation = ">=";
    else if (nextRelation == ">=")
      nextRelation = "<=";

    setEquation(current.right, current.left, relation: nextRelation);
    state = state.copyWith(lastOp: "SYMMETRY PROTOCOL APPLIED");
  }

  void setPreview(String? left, String? right) {
    if (left == null || right == null) {
      state = state.copyWith(previewEquation: null);
    } else {
      state = state.copyWith(
        previewEquation: EquationPair(left: left, right: right),
      );
    }
  }

  void moveTerm(String term, String fromSide, String toSide) {
    // Basic relocation logic: if moving "+5" from Left to Right, apply "-5" to both sides.
    // We parse the term to get its value and operator.
    final match = RegExp(r'^([+-])?\s*(.*)$').firstMatch(term.trim());
    if (match == null) return;

    final op = match.group(1) ?? '+';
    final value = match.group(2) ?? '';
    if (value.isEmpty) return;

    // Inverse operation
    final invOp = op == '+' ? '-' : '+';
    applyOperation(invOp, value);
    state = state.copyWith(lastOp: "PROTOCOL-DRAG: RELOCATED $term");
  }

  void handleTermTap(String term, String side) {
    // Trigger simplification pass on the specific side
    final current = state.equations[state.selectedIndex];
    final isLeft = side == 'LHS';
    if (isLeft) {
      setEquation(_iterativeSimplify(current.left), current.right);
    } else {
      setEquation(current.left, _iterativeSimplify(current.right));
    }
    state = state.copyWith(lastOp: "PROTOCOL-MERGE: CONSOLIDATED TERMS");
  }

  void simplifySide(bool isLeft) {
    final current = state.equations[state.selectedIndex];
    if (isLeft) {
      setEquation(_iterativeSimplify(current.left), current.right);
    } else {
      setEquation(current.left, _iterativeSimplify(current.right));
    }
    final sideStr = isLeft ? "LHS" : "RHS";
    state = state.copyWith(lastOp: "PROTOCOL-MINIMIZE: $sideStr REDUCTION APPLIED");
  }

  String _iterativeSimplify(String raw) {
    try {
      String current = _normalize(raw);
      String previous = "";
      int iterations = 0;
      const int maxIterations = 5;

      while (current != previous && iterations < maxIterations) {
        previous = current;
        final exp = _parser.parse(current);
        // Step 1: Standard math_expressions simplify
        current = exp.simplify().toString().replaceAll(' ', '');

        // Step 2: Custom distributive pass for binomials/polynomials
        // (This is a simplified version, ideally we'd use a full poly-reduction visitor)
        current = _resolveExpression(current);

        iterations++;
      }
      return current;
    } catch (e) {
      return raw;
    }
  }

  void renameVariable(String oldName, String newName) {
    if (oldName == newName || newName.isEmpty) return;

    final updatedEquations = state.equations.map((eq) {
      return EquationPair(
        left: _replaceVar(eq.left, oldName, newName),
        right: _replaceVar(eq.right, oldName, newName),
      );
    }).toList();

    final updatedHistory = state.history.map((hist) {
      final histEqs = hist.equations.map((eq) {
        return EquationPair(
          left: _replaceVar(eq.left, oldName, newName),
          right: _replaceVar(eq.right, oldName, newName),
        );
      }).toList();
      return hist.copyWith(equations: histEqs);
    }).toList();

    state = state.copyWith(
      equations: updatedEquations,
      history: updatedHistory,
    );
    _updateResolvedVariables();
    _updateSuggestions();
  }

  String _replaceVar(String input, String old, String next) {
    return input.replaceAllMapped(RegExp('\\b$old\\b'), (m) => next);
  }

  void applyOperation(String op, String value) {
    if (op == "CROSS") {
      crossMultiply();
      return;
    }
    if (state.equations[state.selectedIndex].left.isEmpty ||
        (state.equations[state.selectedIndex].right.isEmpty && state.history.isEmpty)) {
      return;
    }
    final current = state.equations[state.selectedIndex];
    String nextLeftRaw;
    String nextRightRaw;

    if (op == "SQRT") {
      nextLeftRaw = "(${current.left})^0.5";
      nextRightRaw = "(${current.right})^0.5";
    } else {
      if (value.trim().isEmpty) return;
      nextLeftRaw = "(${current.left}) $op ($value)";
      nextRightRaw = "(${current.right}) $op ($value)";
    }

    String nextRelation = current.relation;
    // Inequality flip logic
    if ((op == "*" || op == "/") && nextRelation != "=") {
      final numValue = double.tryParse(value.trim());
      if (numValue != null && numValue < 0) {
        if (nextRelation == "<")
          nextRelation = ">";
        else if (nextRelation == ">")
          nextRelation = "<";
        else if (nextRelation == "<=")
          nextRelation = ">=";
        else if (nextRelation == ">=")
          nextRelation = "<=";
      }
    }

    try {
      String nextLeft = nextLeftRaw;
      String nextRight = nextRightRaw;

      // We still want to normalize to ensure it's valid, but skip _resolveExpression
      // Actually, if we skip resolve, it might stay messy. Let's join them cleanly.

      final newEq = EquationPair(left: nextLeft, right: nextRight, relation: nextRelation);
      final newEquations = List<EquationPair>.from(state.equations);
      newEquations[state.selectedIndex] = newEq;

      final nextState = state.copyWith(
        equations: newEquations,
        lastOp: "[Eq ${state.selectedIndex + 1}] $op $value",
        history: [...state.history],
      );

      final updatedHistory = [...state.history, nextState];
      state = nextState.copyWith(history: updatedHistory, error: null);
      _updateResolvedVariables();
      _updateSuggestions();
    } catch (e) {
      state = state.copyWith(error: "INVALID OPERATION PARAMETER");
    }
  }

  void factor() {
    final current = state.equations[state.selectedIndex];
    final nextLeft = _factorExpression(current.left);
    if (nextLeft != current.left) {
      setEquation(nextLeft, current.right, relation: current.relation);
    }
  }

  void manualSimplify() {
    final current = state.equations[state.selectedIndex];
    final resolvedLeft = _resolveExpression(current.left);
    final resolvedRight = _resolveExpression(current.right);

    final newEq = EquationPair(left: resolvedLeft, right: resolvedRight, relation: current.relation);
    final newEquations = List<EquationPair>.from(state.equations);
    newEquations[state.selectedIndex] = newEq;

    final nextState = state.copyWith(
      equations: newEquations,
      lastOp: "[Eq ${state.selectedIndex + 1}] MANUAL SIMPLIFICATION EXECUTED",
      history: [...state.history],
    );

    state = nextState.copyWith(history: [...state.history, nextState], error: null);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  String _factorExpression(String raw) {
    try {
      final norm = _normalize(raw);
      final vars = _getVariables(norm);
      if (vars.length != 1) return raw;

      final vName = vars.first;
      final exp = _parser.parse(norm);
      final cm = ContextModel();
      final v = Variable(vName);

      cm.bindVariable(v, Number(0));
      final double f0 = exp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(v, Number(1));
      final double f1 = exp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(v, Number(2));
      final double f2 = exp.evaluate(EvaluationType.REAL, cm);

      final double c = f0;
      final double a = ((f2 - f1) - (f1 - f0)) / 2;
      final double b = f1 - a - c;

      if (a.abs() < 1e-10) return raw; // Not quadratic

      final disc = b * b - 4 * a * c;
      if (disc < 0) return raw; // Complex roots

      final r1 = (-b + sqrt(disc)) / (2 * a);
      final r2 = (-b - sqrt(disc)) / (2 * a);

      String res = "";
      if ((a - 1).abs() > 1e-10) {
        res = _formatDouble(a);
      }

      String term1 = r1.abs() < 1e-10 ? vName : "($vName ${_getOp(r1)} ${_formatDouble(r1.abs())})";
      String term2 = r2.abs() < 1e-10 ? vName : "($vName ${_getOp(r2)} ${_formatDouble(r2.abs())})";

      return "$res$term1$term2";
    } catch (e) {
      return raw;
    }
  }

  String _getOp(double root) {
    // If root is positive, factor is (x - root)
    // If root is negative, factor is (x + abs(root))
    return root > 0 ? "-" : "+";
  }

  void _updateResolvedVariables() {
    final Map<String, String> resolved = {};
    for (final eq in state.equations) {
      final leftVars = _getVariables(eq.left);
      final rightVars = _getVariables(eq.right);

      if (leftVars.length == 1 && rightVars.isEmpty) {
        final varName = leftVars.first;
        if (eq.left == varName && eq.relation == "=") {
          resolved[varName] = eq.right;
        }
      } else if (rightVars.length == 1 && leftVars.isEmpty) {
        final varName = rightVars.first;
        if (eq.right == varName && eq.relation == "=") {
          resolved[varName] = eq.left;
        }
      }
    }
    state = state.copyWith(resolvedVariables: resolved);
  }

  void solve() {
    final current = state.equations[state.selectedIndex];
    if (current.left.isEmpty || current.right.isEmpty) return;

    try {
      final combinedRaw = "(${current.left}) - (${current.right})";
      final normCombined = _normalize(combinedRaw);
      final exp = _parser.parse(normCombined);
      final variables = _getVariables(normCombined);

      if (variables.isEmpty) {
        state = state.copyWith(error: "NO VARIABLES TO SOLVE");
        return;
      }
      if (variables.length > 1) {
        state = state.copyWith(error: "CAN ONLY AUTO-SOLVE SINGLE VARIABLE");
        return;
      }

      final varName = variables.first;
      final cm = ContextModel();
      final v = Variable(varName);

      cm.bindVariable(v, Number(0));
      final double f0 = exp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(v, Number(1));
      final double f1 = exp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(v, Number(2));
      final double f2 = exp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(v, Number(3));
      final double f3 = exp.evaluate(EvaluationType.REAL, cm);

      final slope = f1 - f0;
      final accel1 = (f2 - f1) - (f1 - f0);
      final accel2 = (f3 - f2) - (f2 - f1);

      // Linear check
      if (accel1.abs() < 1e-10) {
        if (slope.abs() < 1e-10) {
          state = state.copyWith(error: (f0.abs() < 1e-10) ? "INFINITE SOLUTIONS" : "NO SOLUTION");
          return;
        }
        final double solution = -f0 / slope;
        String nextRelation = current.relation;
        if (slope < 0 && nextRelation != "=") {
          if (nextRelation == "<")
            nextRelation = ">";
          else if (nextRelation == ">")
            nextRelation = "<";
          else if (nextRelation == "<=")
            nextRelation = ">=";
          else if (nextRelation == ">=")
            nextRelation = "<=";
        }
        _applySolution(varName, _formatDouble(solution), relation: nextRelation);
        return;
      }

      // Quadratic check: ax^2 + bx + c [rel] 0
      if ((accel1 - accel2).abs() > 1e-10) {
        state = state.copyWith(error: "ANALYTIC SOLVER FAILED - EXECUTE CROSS-MULTIPLICATION");
        return;
      }

      final double c = f0;
      final double a = accel1 / 2;
      final double b = f1 - a - c;
      final String rel = current.relation;

      if (rel == "=") {
        final discriminant = b * b - 4 * a * c;
        if (discriminant < 0) {
          state = state.copyWith(error: "NO REAL ROOTS (NON-BUREAUCRATIC)");
        } else if (discriminant.abs() < 1e-10) {
          final double root = -b / (2 * a);
          _applySolution(varName, _formatDouble(root), relation: "=");
        } else {
          final settings = ref.read(settingsCtrlProvider);
          if (settings.isRadicalMode) {
            final radicalResult = _formatRadical(a, b, discriminant);
            if (radicalResult.isNotEmpty) {
              _applySolution(varName, radicalResult, relation: "=");
              return;
            }
          }
          final double root1 = (-b + sqrt(discriminant)) / (2 * a);
          final double root2 = (-b - sqrt(discriminant)) / (2 * a);
          _applySolution(varName, "${_formatDouble(root1)}, ${_formatDouble(root2)}", relation: "=");
        }
        return;
      }

      // Inequality Solution Sets
      bool test(double x) {
        final val = a * x * x + b * x + c;
        if (rel == "<") return val < -1e-10;
        if (rel == ">") return val > 1e-10;
        if (rel == "<=") return val <= 1e-10;
        if (rel == ">=") return val >= -1e-10;
        return false;
      }

      final discriminant = b * b - 4 * a * c;

      if (discriminant < -1e-10) {
        // No roots -> always same sign. Test x=0
        if (test(0)) {
          state = state.copyWith(
            error: "SYSTEM STABILIZED: ALL REAL NUMBERS VALID",
            showAuditStamp: true,
          );
        } else {
          state = state.copyWith(
            error: "NODE COLLAPSE: NO SOLUTION DETECTED",
            showAuditStamp: true,
          );
        }
      } else if (discriminant.abs() <= 1e-10) {
        // One root r. Test points slightly left and right
        final r = -b / (2 * a);
        final satisfyR = test(r);
        final satisfyL = test(r - 1);
        final satisfyRight = test(r + 1);

        if (satisfyL && satisfyRight) {
          if (satisfyR) {
            state = state.copyWith(error: "SYSTEM STABILIZED: ALL REAL NUMBERS VALID", showAuditStamp: true);
          } else {
            state = state.copyWith(error: "STABILIZED: $varName != ${_formatDouble(r)}", showAuditStamp: true);
          }
        } else if (!satisfyL && !satisfyRight) {
          if (satisfyR) {
            _applySolution(varName, _formatDouble(r), relation: "=");
          } else {
            state = state.copyWith(error: "NODE COLLAPSE: NO SOLUTION DETECTED", showAuditStamp: true);
          }
        } else {
          // Parabola shouldn't do this if it's quadratic (only 1 root)
          // But for robustness:
          _applySolution(varName, _formatDouble(r), relation: satisfyL ? "<=" : ">=");
        }
      } else {
        // Two roots r1, r2
        double r1 = (-b - sqrt(discriminant)) / (2 * a);
        double r2 = (-b + sqrt(discriminant)) / (2 * a);
        if (r1 > r2) {
          final temp = r1;
          r1 = r2;
          r2 = temp;
        }

        final bool satisfyBetween = test((r1 + r2) / 2);
        final bool satisfyOutside = test(r1 - 1);
        final bool satisfyR1 = test(r1);

        final s1 = _formatDouble(r1);
        final s2 = _formatDouble(r2);

        if (satisfyBetween) {
          // r1 [rel] x [rel] r2
          // Wait, if satisfyBetween and a > 0, rel must be <. If a < 0, rel must be >.
          // Simplest is to just format the interval properly: r1 < x < r2
          final op1 = rel.contains("=") ? "<=" : "<";
          state = state.copyWith(
            error: "SOLVED: $s1 $op1 $varName $op1 $s2",
            showAuditStamp: true,
          );
        } else if (satisfyOutside) {
          // x < r1 or x > r2
          final opL = rel.contains("=") ? "<=" : "<";
          final opR = rel.contains("=") ? ">=" : ">";
          state = state.copyWith(
            error: "SOLVED: $varName $opL $s1 OR $varName $opR $s2",
            showAuditStamp: true,
          );
        } else {
          // Only the roots themselves?
          if (satisfyR1) {
            state = state.copyWith(error: "STABILIZED: $varName = $s1, $s2", showAuditStamp: true);
          } else {
            state = state.copyWith(error: "NODE COLLAPSE: NO SOLUTION DETECTED", showAuditStamp: true);
          }
        }
      }
    } catch (e) {
      state = state.copyWith(
        error: "AUTO-SOLVE ERROR",
        showAuditStamp: true,
      );
    }
  }

  void _applySolution(String varName, String solution, {String relation = "="}) {
    final newEq = EquationPair(left: varName, right: solution, relation: relation);
    final newEquations = List<EquationPair>.from(state.equations);
    newEquations[state.selectedIndex] = newEq;

    final nextState = state.copyWith(
      equations: newEquations,
      lastOp: "[Eq ${state.selectedIndex + 1}] AUTO-SOLVE",
      history: [...state.history],
    );

    state = nextState.copyWith(history: [...state.history, nextState], error: null);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  void solveSystem() {
    if (state.multiSelectIndices.length != 2) {
      state = state.copyWith(error: "SELECT EXACTLY 2 NODES FOR SYSTEMS ANALYSIS");
      return;
    }

    try {
      final eq1 = state.equations[state.multiSelectIndices[0]];
      final eq2 = state.equations[state.multiSelectIndices[1]];

      final vars = _getVariables(_normalize("${eq1.left}${eq1.right}${eq2.left}${eq2.right}"));

      if (vars.length != 2) {
        state = state.copyWith(error: "SYSTEMS ANALYSIS REQUIRES EXACTLY 2 VARIABLES");
        return;
      }

      final v1 = vars.first;
      final v2 = vars.last;

      // We need to convert each eq to standard form: a*v1 + b*v2 = c
      // Sampling for eq1: f(v1, v2) = LHS - RHS
      final exp1 = _parser.parse(_normalize("(${eq1.left}) - (${eq1.right})"));
      final exp2 = _parser.parse(_normalize("(${eq2.left}) - (${eq2.right})"));

      final cm = ContextModel();
      final var1 = Variable(v1);
      final var2 = Variable(v2);

      // eq1: a1*v1 + b1*v2 + c1 = 0 => a1*v1 + b1*v2 = -c1
      cm.bindVariable(var1, Number(0));
      cm.bindVariable(var2, Number(0));
      final c1 = exp1.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(var1, Number(1));
      final a1 = exp1.evaluate(EvaluationType.REAL, cm) - c1;
      cm.bindVariable(var1, Number(0));
      cm.bindVariable(var2, Number(1));
      final b1 = exp1.evaluate(EvaluationType.REAL, cm) - c1;

      // eq2: a2*v1 + b2*v2 + c2 = 0 => a2*v1 + b2*v2 = -c2
      cm.bindVariable(var1, Number(0));
      cm.bindVariable(var2, Number(0));
      final c2 = exp2.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(var1, Number(1));
      final a2 = exp2.evaluate(EvaluationType.REAL, cm) - c2;
      cm.bindVariable(var1, Number(0));
      cm.bindVariable(var2, Number(1));
      final b2 = exp2.evaluate(EvaluationType.REAL, cm) - c2;

      // Cramer's Rule
      // a1*v1 + b1*v2 = -c1
      // a2*v1 + b2*v2 = -c2
      final C1 = -c1;
      final C2 = -c2;

      final det = a1 * b2 - a2 * b1;
      if (det.abs() < 1e-10) {
        state = state.copyWith(error: "SYSTEM IS SINGULAR OR LINEARLY DEPENDENT");
        return;
      }

      final solV1 = (C1 * b2 - C2 * b1) / det;
      final solV2 = (a1 * C2 - a2 * C1) / det;

      state = state.copyWith(
        error: "SYSTEM SOLVED: $v1=${_formatDouble(solV1)}, $v2=${_formatDouble(solV2)}",
        lastOp: "SYSTEMS ANALYSIS COMPLETED",
        showAuditStamp: true,
      );
    } catch (e) {
      state = state.copyWith(error: "SYSTEMS ANALYSIS FAILED");
    }
  }

  void toggleMultiSelect(int index) {
    var newList = List<int>.from(state.multiSelectIndices);
    if (newList.contains(index)) {
      newList.remove(index);
    } else {
      newList.add(index);
    }
    state = state.copyWith(multiSelectIndices: newList);
  }

  void symbolicExpand() {
    final current = state.equations[state.selectedIndex];
    final left = _iterativeSimplify(current.left);
    final right = _iterativeSimplify(current.right);

    final nextState = state.copyWith(
      equations: [
        ...state.equations.sublist(0, state.selectedIndex),
        EquationPair(left: left, right: right, relation: current.relation),
        ...state.equations.sublist(state.selectedIndex + 1),
      ],
      lastOp: "SYMBOLIC EXPANSION APPLIED",
      history: [...state.history],
    );
    state = nextState.copyWith(history: [...state.history, nextState]);
    _updateSuggestions();
  }

  void centralize() {
    final current = state.equations[state.selectedIndex];
    if (current.left.isEmpty || current.right.isEmpty) return;

    // Step 1: Expand and Normalize
    String left = _iterativeSimplify(current.left);
    String right = _iterativeSimplify(current.right);

    // Step 2: Term Separation
    final leftTerms = _getSeparatedTerms(left);
    final rightTerms = _getSeparatedTerms(right);

    List<String> newLeft = [];
    List<String> newRight = [];

    // Protocol: Variables -> LHS, Constants -> RHS
    // Move constants from LHS to RHS (inverse)
    for (final term in leftTerms) {
      if (_getVariables(term).isEmpty) {
        newRight.add(_invertTerm(term));
      } else {
        newLeft.add(term);
      }
    }

    // Move variables from RHS to LHS (inverse)
    for (final term in rightTerms) {
      if (_getVariables(term).isNotEmpty) {
        newLeft.add(_invertTerm(term));
      } else {
        newRight.add(term);
      }
    }

    String finalLeft = newLeft.isEmpty ? "0" : newLeft.join(" + ");
    String finalRight = newRight.isEmpty ? "0" : newRight.join(" + ");

    // Step 3: Resolution Pass
    final resolvedLeft = _resolveExpression(finalLeft);
    final resolvedRight = _resolveExpression(finalRight);

    final nextState = state.copyWith(
      equations: [
        ...state.equations.sublist(0, state.selectedIndex),
        EquationPair(left: resolvedLeft, right: resolvedRight, relation: current.relation),
        ...state.equations.sublist(state.selectedIndex + 1),
      ],
      lastOp: "CENTRALIZATION PROTOCOL EXECUTED",
      history: [...state.history],
    );
    state = nextState.copyWith(history: [...state.history, nextState]);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  List<String> _getSeparatedTerms(String input) {
    if (input.isEmpty) return [];

    // Protocol: Split by top-level addition/subtraction, preserving operators.
    // We iterate through keeping track of parenthesis depth to avoid splitting inside radicals or groups.
    final terms = <String>[];
    String currentTerm = "";
    int depth = 0;

    // Normalize: replace '-' with '+-' for easier splitting, but only at top level.
    String normalized = input.replaceAll(' ', '');

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

    return terms.where((t) => t.isNotEmpty).toList();
  }

  String _invertTerm(String term) {
    final trimmed = term.trim();
    if (trimmed.startsWith('-')) {
      return trimmed.substring(1);
    }
    return "-$trimmed";
  }

  void crossMultiply() {
    final eq = state.equations[state.selectedIndex];
    final leftParts = _extractFractionParts(eq.left);
    final rightParts = _extractFractionParts(eq.right);

    if (leftParts == null || rightParts == null) {
      state = state.copyWith(error: "INVALID PROPORTIONAL FORMAT");
      return;
    }

    // Cross Multiply: L_num * R_den = R_num * L_num
    final nextLeftRaw = "(${leftParts.numerator}) * (${rightParts.denominator})";
    final nextRightRaw = "(${rightParts.numerator}) * (${leftParts.denominator})";

    final resolvedLeft = _resolveExpression(nextLeftRaw);
    final resolvedRight = _resolveExpression(nextRightRaw);

    final nextState = state.copyWith(
      equations: [
        ...state.equations.sublist(0, state.selectedIndex),
        EquationPair(left: resolvedLeft, right: resolvedRight, relation: eq.relation),
        ...state.equations.sublist(state.selectedIndex + 1),
      ],
      lastOp: "CROSS-MULTIPLICATION PROTOCOL EXECUTED",
      history: [...state.history],
    );
    state = nextState.copyWith(history: [...state.history, nextState]);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  ({String numerator, String denominator})? _extractFractionParts(String side) {
    if (side.isEmpty) return (numerator: "0", denominator: "1");
    try {
      final normalized = _normalize(side);
      final exp = _parser.parse(normalized);
      if (exp is Divide) {
        return (
          numerator: exp.first.toString().replaceAll(' ', ''),
          denominator: exp.second.toString().replaceAll(' ', ''),
        );
      }
      return (numerator: normalized, denominator: "1");
    } catch (_) {
      return null;
    }
  }

  void toggleAutoSolve() {
    ref.read(settingsCtrlProvider.notifier).toggleAutoSolve();
    final newState = ref.read(settingsCtrlProvider).isAutoSolveEnabled;
    state = state.copyWith(
      lastOp: newState ? "UNSANCTIONED SOLVE UNIT COMMISSIONED" : "AUTOMATION DE-COMMISSIONED",
    );
  }

  void _updateSuggestions() {
    final currentEq = state.equations[state.selectedIndex];
    final leftNorm = _normalize(currentEq.left);
    final rightNorm = _normalize(currentEq.right);
    final leftVars = _getVariables(leftNorm);
    final rightVars = _getVariables(rightNorm);

    // If solved: x = [const] or [const] = x
    bool isSolved = false;
    if (leftVars.length == 1 && rightVars.isEmpty) {
      if (leftNorm == leftVars.first) isSolved = true;
    } else if (rightVars.length == 1 && leftVars.isEmpty) {
      if (rightNorm == rightVars.first) isSolved = true;
    }

    if (isSolved) {
      state = state.copyWith(suggestions: []);
      _checkAutoSolved();
      return;
    }

    final allVars = {...leftVars, ...rightVars};
    List<OperationSuggestion> suggestions = [];

    // Proportional Detection
    final lExp = _parser.parse(leftNorm.isEmpty ? "0" : leftNorm);
    final rExp = _parser.parse(rightNorm.isEmpty ? "0" : rightNorm);
    if (lExp is Divide || rExp is Divide) {
      // Basic check: don't suggest if it's just a single number over 1 unless it helps
      // But for algebra tool, it's safer to show it if there's a fraction involved.
      suggestions.add(
        const OperationSuggestion(
          op: "CROSS",
          value: "MULTIPLY",
          justification: "RESOLVE PROPORTIONAL RELATIONSHIP",
        ),
      );
    }

    if (allVars.length == 1) {
      final v = allVars.first;
      final cm = ContextModel();
      final variable = Variable(v);

      // Evaluate Left Side
      final leftExp = _parser.parse(leftNorm.isEmpty ? "0" : leftNorm);
      cm.bindVariable(variable, Number(0));
      final double leftConst = leftExp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(variable, Number(1));
      final double leftCoeff = leftExp.evaluate(EvaluationType.REAL, cm) - leftConst;

      // Evaluate Right Side
      final rightExp = _parser.parse(rightNorm.isEmpty ? "0" : rightNorm);
      cm.bindVariable(variable, Number(0));
      final double rightConst = rightExp.evaluate(EvaluationType.REAL, cm);
      cm.bindVariable(variable, Number(1));
      final double rightCoeff = rightExp.evaluate(EvaluationType.REAL, cm) - rightConst;

      // Neutralize Constants
      if (leftConst.abs() > 1e-10) {
        suggestions.add(
          OperationSuggestion(
            op: leftConst > 0 ? '-' : '+',
            value: _formatDouble(leftConst.abs()),
            justification: "NEUTRALIZE LEFT CONSTANT",
          ),
        );
      }
      if (rightConst.abs() > 1e-10) {
        suggestions.add(
          OperationSuggestion(
            op: rightConst > 0 ? '-' : '+',
            value: _formatDouble(rightConst.abs()),
            justification: "NEUTRALIZE RIGHT CONSTANT",
          ),
        );
      }

      // Centralize Variables
      if (rightCoeff.abs() > 1e-10) {
        suggestions.add(
          OperationSuggestion(
            op: rightCoeff > 0 ? '-' : '+',
            value: rightCoeff.abs() == 1 ? v : "${_formatDouble(rightCoeff.abs())}$v",
            justification: "CENTRALIZE VARIABLES",
          ),
        );
      }

      // Isolate Variable (Division) - Only if constant is zero on one side and variable is zero on the other
      if (leftCoeff.abs() > 1e-10 && leftCoeff.abs() != 1 && (leftConst.abs() < 1e-10) && (rightCoeff.abs() < 1e-10)) {
        suggestions.add(
          OperationSuggestion(
            op: '/',
            value: _formatDouble(leftCoeff),
            justification: "ISOLATE VARIABLE",
          ),
        );
      }

      // Factoring Suggestion
      if (leftVars.isNotEmpty && !leftNorm.contains('(') && !leftNorm.contains(')')) {
        final factored = _factorExpression(leftNorm);
        if (factored != leftNorm) {
          suggestions.add(
            OperationSuggestion(
              op: 'FACTOR',
              value: leftNorm,
              justification: "DECOMPOSE POLYNOMIAL",
            ),
          );
        }
      }
    }

    state = state.copyWith(suggestions: suggestions);
    _checkAutoSolved();
  }

  void _checkAutoSolved() {
    if (state.showAuditStamp) return;

    final currentEq = state.equations[state.selectedIndex];
    final leftNorm = _normalize(currentEq.left);
    final rightNorm = _normalize(currentEq.right);

    final leftVars = _getVariables(leftNorm);
    final rightVars = _getVariables(rightNorm);

    // Solved if: x = [const] or [const] = x
    bool isSolved = false;

    if (leftVars.length == 1 && rightVars.isEmpty) {
      if (leftNorm == leftVars.first) isSolved = true;
    } else if (rightVars.length == 1 && leftVars.isEmpty) {
      if (rightNorm == rightVars.first) isSolved = true;
    }

    if (isSolved) {
      state = state.copyWith(showAuditStamp: true);
    }
  }

  void refreshAndResolve() {
    final updatedEquations = state.equations
        .map(
          (eq) => EquationPair(
            left: _resolveExpression(eq.left),
            right: _resolveExpression(eq.right),
            relation: eq.relation,
          ),
        )
        .toList();
    state = state.copyWith(equations: updatedEquations);
    _updateResolvedVariables();
  }

  String _resolveExpression(String raw) {
    try {
      final normalized = _normalize(raw);
      if (normalized.isEmpty) return "";

      final exp = _parser.parse(normalized);
      final variables = _getVariables(normalized);

      if (variables.isEmpty) {
        return _formatDouble(exp.evaluate(EvaluationType.REAL, ContextModel()));
      }

      if (variables.length == 1) {
        final varName = variables.first;
        final cm = ContextModel();
        final v = Variable(varName);

        cm.bindVariable(v, Number(0));
        final double f0 = exp.evaluate(EvaluationType.REAL, cm);
        cm.bindVariable(v, Number(1));
        final double f1 = exp.evaluate(EvaluationType.REAL, cm);
        cm.bindVariable(v, Number(2));
        final double f2 = exp.evaluate(EvaluationType.REAL, cm);
        cm.bindVariable(v, Number(3));
        final double f3 = exp.evaluate(EvaluationType.REAL, cm);

        final accel1 = (f2 - f1) - (f1 - f0);
        final accel2 = (f3 - f2) - (f2 - f1);

        if ((f1 - f0 - (f2 - f1)).abs() < 1e-10) {
          final slope = f1 - f0;
          final intercept = f0;

          if (slope.abs() < 1e-10) return _formatDouble(intercept);

          String res = "";
          if ((slope - 1).abs() < 1e-10) {
            res = varName;
          } else if ((slope + 1).abs() < 1e-10) {
            res = "-$varName";
          } else {
            res = "${_formatDouble(slope)}$varName";
          }

          if (intercept > 1e-10) {
            res += " + ${_formatDouble(intercept)}";
          } else if (intercept < -1e-10) {
            res += " - ${_formatDouble(intercept.abs())}";
          }
          return res;
        } else if ((accel1 - accel2).abs() < 1e-10) {
          // Quadratic check in resolve
          final double c = f0;
          final double a = accel1 / 2;
          final double b = f1 - a - c;

          String res = "";
          if (a.abs() > 1e-10) {
            res = "${_formatDouble(a)}$varName^2";
          }

          final slope = b;
          if (slope.abs() > 1e-10) {
            if (res.isNotEmpty) {
              res += slope > 0 ? " + " : " - ";
              res += (slope.abs() - 1).abs() < 1e-10 ? varName : "${_formatDouble(slope.abs())}$varName";
            } else {
              res = (slope - 1).abs() < 1e-10
                  ? varName
                  : (slope + 1).abs() < 1e-10
                  ? "-$varName"
                  : "${_formatDouble(slope)}$varName";
            }
          }

          if (c.abs() > 1e-10) {
            if (res.isNotEmpty) {
              res += c > 0 ? " + " : " - ";
              res += _formatDouble(c.abs());
            } else {
              res = _formatDouble(c);
            }
          }
          return res.isEmpty ? "0" : res;
        }
      }

      return exp.simplify().toString().replaceAll(' ', '');
    } catch (e) {
      return raw.trim();
    }
  }

  Set<String> _getVariables(String input) {
    final matches = RegExp(r'\b[a-zA-Z]\b').allMatches(input);
    return matches.map((m) => m.group(0)!).toSet();
  }

  String _formatDouble(double d) {
    if (d.isInfinite || d.isNaN) return "ERR";

    final settings = ref.read(settingsCtrlProvider);
    if (settings.isRationalMode) {
      return _toFraction(d);
    }

    String fixed = d.toStringAsFixed(10);
    double rounded = double.parse(fixed);

    if ((rounded - rounded.round()).abs() < 1e-10) {
      return rounded.round().toString();
    }

    var s = rounded.toString();
    if (s.endsWith('.0')) {
      s = s.substring(0, s.length - 2);
    }

    return s;
  }

  String _toFraction(double d) {
    if ((d - d.round()).abs() < 1e-10) return d.round().toString();

    final bool isNegative = d < 0;
    final double val = d.abs();

    const double tolerance = 1e-9;
    double h1 = 1, h2 = 0, k1 = 0, k2 = 1;
    double b = val;
    do {
      double a = b.floorToDouble();
      double aux = h1;
      h1 = a * h1 + h2;
      h2 = aux;
      aux = k1;
      k1 = a * k1 + k2;
      k2 = aux;
      if (b - a < tolerance) break;
      b = 1 / (b - a);
    } while ((val - h1 / k1).abs() > val * tolerance && k1 < 1000000);

    final int num = h1.toInt();
    final int den = k1.toInt();

    if (den == 1) return (isNegative ? -num : num).toString();
    return "${isNegative ? -num : num}/$den";
  }

  (int, int) _simplifyRadical(int n) {
    if (n < 0) return (1, n);
    if (n == 0) return (0, 0);
    int factor = 1;
    int radicand = n;
    for (int i = 2; i * i <= radicand; i++) {
      while (radicand % (i * i) == 0) {
        factor *= i;
        radicand ~/= (i * i);
      }
    }
    return (factor, radicand);
  }

  String _formatRadical(double a, double b, double discriminant) {
    // Standard quadratic formula: (-b +/- sqrt(D)) / 2a
    // We only call this if settings.isRadicalMode is true and D is not a perfect square but is a positive integer
    if (discriminant < 0) return "";
    final int discInt = discriminant.round();
    if ((discriminant - discInt).abs() > 1e-10) return "";

    final (factor, radicand) = _simplifyRadical(discInt);
    final denom = (2 * a).round();

    // Case: sqrt(D) is a perfect square (already handled usually, but just in case)
    if (radicand == 1) return "";

    // Result is (-b + factor*sqrt(radicand)) / denom
    // and (-b - factor*sqrt(radicand)) / denom

    String formatPart(bool positive) {
      final double bVal = -b;
      final double fVal = positive ? factor.toDouble() : -factor.toDouble();

      // Check if bVal and factor are both divisible by denom
      if ((bVal % denom).abs() < 1e-10 && (fVal % denom).abs() < 1e-10) {
        final int bFinal = (bVal ~/ denom);
        final int fFinalRaw = (fVal ~/ denom).toInt();
        final int fFinal = fFinalRaw.abs();
        final String sign = positive ? (bFinal == 0 ? "" : " + ") : (bFinal == 0 ? "-" : " - ");

        String res = "";
        if (bFinal != 0) res += bFinal.toString();
        if (fFinal != 1) {
          res += "$sign$fFinal*sqrt($radicand)";
        } else {
          res += "${sign}sqrt($radicand)";
        }
        return res;
      }

      // Otherwise, return as a fraction-like string if possible or just the raw formula
      final String top = "${_formatDouble(bVal)} ${positive ? '+' : '-'} ($factor*sqrt($radicand))";
      return "($top)/$denom";
    }

    return "${formatPart(true)}, ${formatPart(false)}";
  }

  String _normalize(String input) {
    var s = input.replaceAll(' ', '').replaceAll(',', '.');
    // Normalize dashes
    s = s.replaceAll('–', '-').replaceAll('—', '-');
    s = s.replaceAll('√', 'sqrt');
    s = s.replaceAllMapped(RegExp(r'(^|[^0-9])\.(\d)'), (m) => '${m[1]}0.${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(\d+\.?\d*)([a-zA-Z])'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])(\d)'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])([a-zA-Z])'), (m) => '${m[1]}*${m[2]}');
    s = s.replaceAllMapped(RegExp(r'(\d+\.?\d*)\('), (m) => '${m[1]}*(');
    s = s.replaceAllMapped(RegExp(r'([a-zA-Z])\('), (m) => '${m[1]}*(');
    s = s.replaceAllMapped(RegExp(r'\)([a-zA-Z])'), (m) => ')*${m[1]}');
    s = s.replaceAllMapped(RegExp(r'\)(\d)'), (m) => ')*${m[1]}');
    s = s.replaceAllMapped(RegExp(r'\)\('), (m) => ')*(');
    return s;
  }

  void undo() {
    if (state.history.length <= 1) return;
    final newHistory = List<AlgebraState>.from(state.history)..removeLast();
    state = newHistory.last.copyWith(history: newHistory);
    _updateResolvedVariables();
    _updateSuggestions();
  }

  void clear() {
    state = build();
    _updateSuggestions();
  }

  void clearStamp() {
    state = state.copyWith(showAuditStamp: false);
  }
}

class EquationPair {
  final String left;
  final String right;
  final String relation;
  const EquationPair({required this.left, required this.right, this.relation = "="});
}

class OperationSuggestion {
  final String op;
  final String value;
  final String justification;
  const OperationSuggestion({
    required this.op,
    required this.value,
    required this.justification,
  });

  String get display => "$op $value";
}

class AlgebraState {
  final List<EquationPair> equations;
  final int selectedIndex;
  final String? lastOp;
  final List<AlgebraState> history;
  final String? error;
  final Map<String, String> resolvedVariables;
  final List<int> multiSelectIndices;
  final List<OperationSuggestion> suggestions;
  final bool showAuditStamp;
  final EquationPair? previewEquation;

  const AlgebraState({
    this.equations = const [EquationPair(left: "", right: "")],
    this.selectedIndex = 0,
    this.lastOp,
    this.history = const [],
    this.error,
    this.resolvedVariables = const {},
    this.multiSelectIndices = const [],
    this.suggestions = const [],
    this.showAuditStamp = false,
    this.previewEquation,
  });

  String get leftSide => equations[selectedIndex].left;
  String get rightSide => equations[selectedIndex].right;

  AlgebraState copyWith({
    List<EquationPair>? equations,
    int? selectedIndex,
    String? lastOp,
    List<AlgebraState>? history,
    String? error,
    Map<String, String>? resolvedVariables,
    List<int>? multiSelectIndices,
    List<OperationSuggestion>? suggestions,
    bool? showAuditStamp,
    EquationPair? previewEquation,
  }) {
    return AlgebraState(
      equations: equations ?? this.equations,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      lastOp: lastOp ?? this.lastOp,
      history: history ?? this.history,
      error: error,
      resolvedVariables: resolvedVariables ?? this.resolvedVariables,
      multiSelectIndices: multiSelectIndices ?? this.multiSelectIndices,
      suggestions: suggestions ?? this.suggestions,
      showAuditStamp: showAuditStamp ?? this.showAuditStamp,
      previewEquation: previewEquation ?? this.previewEquation,
    );
  }
}
