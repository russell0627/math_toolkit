import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'features/app/presentation/widgets/bureau_atmosphere.dart';
import 'features/app/services/app/app_service.dart';
import 'features/app/services/theme/theme_service.dart';
import 'features/app/services/persistence/persistence_service.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appServiceProvider);

    final themeState = ref.watch(themeServiceProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'App Template',
      theme: themeState.light,
      darkTheme: themeState.dark,
      themeMode: themeState.mode,
      restorationScopeId: 'app',
      routerConfig: ref.watch(goRouterProvider),
      builder: (context, child) {
        final smartDialogBuilder = FlutterSmartDialog.init();
        return BureauAtmosphere(
          child: smartDialogBuilder(context, child),
        );
      },
    );
  }
}
