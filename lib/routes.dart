import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'features/algebra/presentation/algebra_guide_screen.dart';
import 'features/algebra/presentation/algebra_screen.dart';
import 'features/app/presentation/home_page.dart';
import 'features/app/presentation/not_found_page.dart';
import 'features/budget_audit/presentation/budgetary_audit_screen.dart';
import 'features/calculator/presentation/calculator_screen.dart';
import 'features/cipher/presentation/cipher_screen.dart';
import 'features/elements/presentation/elemental_registry_screen.dart';
import 'features/fraction_simplifier/presentation/fraction_simplifier_view.dart';
import 'features/synchronizer/presentation/synchronizer_screen.dart';
import 'features/app/presentation/pi_stream_screen.dart';
import 'features/app/presentation/prime_sieve_screen.dart';
import 'features/app/presentation/signal_auditor_screen.dart';
import 'features/minesweeper/presentation/minesweeper_screen.dart';
import 'features/triangle_solver/presentation/triangle_solver_screen.dart';
import 'features/pythagorean/presentation/pythagorean_screen.dart';
import 'features/radical_simplifier/presentation/radical_screen.dart';
import 'features/fraction_simplifier/presentation/fraction_simplifier_screen.dart';
import 'features/workbench/presentation/workbench_screen.dart';

part 'routes.g.dart';

enum AppRoute {
  home('/'),
  calculator('/calculator'),
  fractionSimplifier('/fraction-simplifier'),
  budgetAudit('/budget-audit'),
  cipher('/cipher'),
  synchronizer('/synchronizer'),
  algebra('/algebra'),
  algebraGuide('/algebra-guide'),
  elementalRegistry('/elemental-registry'),
  piStream('/pi-stream'),
  primeSieve('/prime-sieve'),
  signalAuditor('/signal-auditor'),
  minesweeper('/minesweeper'),
  triangleSolver('/triangle-solver'),
  pythagorean('/pythagorean'),
  radicalSimplifier('/radical-simplifier'),
  workbench('/workbench')
  ;

  final String? _path;

  String get path => _path ?? name;

  const AppRoute([this._path]);
}

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    debugLogDiagnostics: false,
    routerNeglect: true,
    initialLocation: AppRoute.home.path,
    observers: [FlutterSmartDialog.observer],
    routes: [
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            name: AppRoute.calculator.name,
            path: AppRoute.calculator.path,
            builder: (context, state) => const CalculatorScreen(),
          ),
          GoRoute(
            name: AppRoute.fractionSimplifier.name,
            path: AppRoute.fractionSimplifier.path,
            builder: (context, state) => const FractionSimplifierScreen(),
          ),
          GoRoute(
            name: AppRoute.budgetAudit.name,
            path: AppRoute.budgetAudit.path,
            builder: (context, state) => const BudgetaryAuditScreen(),
          ),
          GoRoute(
            name: AppRoute.cipher.name,
            path: AppRoute.cipher.name,
            builder: (context, state) => const CipherScreen(),
          ),
          GoRoute(
            name: AppRoute.synchronizer.name,
            path: AppRoute.synchronizer.path,
            builder: (context, state) => const SynchronizerScreen(),
          ),
          GoRoute(
            name: AppRoute.algebra.name,
            path: AppRoute.algebra.path,
            builder: (context, state) => const AlgebraScreen(),
          ),
          GoRoute(
            name: AppRoute.algebraGuide.name,
            path: AppRoute.algebraGuide.path,
            builder: (context, state) => const AlgebraGuideScreen(),
          ),
          GoRoute(
            name: AppRoute.elementalRegistry.name,
            path: AppRoute.elementalRegistry.path,
            builder: (context, state) => const ElementalRegistryScreen(),
          ),
          GoRoute(
            name: AppRoute.piStream.name,
            path: AppRoute.piStream.path,
            builder: (context, state) => const PiStreamScreen(),
          ),
          GoRoute(
            name: AppRoute.primeSieve.name,
            path: AppRoute.primeSieve.path,
            builder: (context, state) => const PrimeSieveScreen(),
          ),
          GoRoute(
            name: AppRoute.signalAuditor.name,
            path: AppRoute.signalAuditor.path,
            builder: (context, state) => const SignalAuditorScreen(),
          ),
          GoRoute(
            name: AppRoute.minesweeper.name,
            path: AppRoute.minesweeper.path,
            builder: (context, state) => MinesweeperScreen(),
          ),
          GoRoute(
            name: AppRoute.triangleSolver.name,
            path: AppRoute.triangleSolver.path,
            builder: (context, state) => const TriangleSolverScreen(),
          ),
          GoRoute(
            name: AppRoute.pythagorean.name,
            path: AppRoute.pythagorean.path,
            builder: (context, state) => const PythagoreanScreen(),
          ),
          GoRoute(
            name: AppRoute.radicalSimplifier.name,
            path: AppRoute.radicalSimplifier.path,
            builder: (context, state) => const RadicalScreen(),
          ),
          GoRoute(
            name: AppRoute.workbench.name,
            path: AppRoute.workbench.path,
            builder: (context, state) => const WorkbenchScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
