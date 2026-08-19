import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_tools/features/algebra/controller/algebra_ctrl.dart';
import 'package:math_tools/features/app/services/persistence/persistence_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
  }

  test('Single variable solve', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final notifier = container.read(algebraCtrlProvider.notifier);
    notifier.setEquation('2*x + 4', '10');
    expect(container.read(algebraCtrlProvider).error, null);

    notifier.solve();
    final state = container.read(algebraCtrlProvider);
    expect(state.error, null);
    expect(state.equations.first.left, 'x');
    expect(state.equations.first.right, '3');
  });

  test('Multi-variable isolate variable x: 2*x + 3*y = 12', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final notifier = container.read(algebraCtrlProvider.notifier);
    notifier.setEquation('2*x + 3*y', '12');
    expect(container.read(algebraCtrlProvider).error, null);

    notifier.solve();
    final state = container.read(algebraCtrlProvider);
    expect(state.error, null);
    expect(state.equations.first.left, 'x');
    expect(state.equations.first.right, '-1.5y + 6');
  });

  test('Multi-variable isolate variable x: x + y = 10', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final notifier = container.read(algebraCtrlProvider.notifier);
    notifier.setEquation('x + y', '10');
    expect(container.read(algebraCtrlProvider).error, null);

    notifier.solve();
    final state = container.read(algebraCtrlProvider);
    expect(state.error, null);
    expect(state.equations.first.left, 'x');
    expect(state.equations.first.right, '-y + 10');
  });

  test('Explicit isolate variable y in multi-variable equation', () {
    final container = createContainer();
    addTearDown(container.dispose);

    final notifier = container.read(algebraCtrlProvider.notifier);
    notifier.setEquation('2*x + 3*y', '12');
    expect(container.read(algebraCtrlProvider).error, null);

    notifier.isolateVariable('y');
    final state = container.read(algebraCtrlProvider);
    expect(state.error, null);
    expect(state.equations.first.left, 'y');
    expect(state.equations.first.right, '-0.6666666667x + 4');
  });
}
