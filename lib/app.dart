import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/config/app_environment.dart';
import 'core/router/app_router.dart';
import 'core/ui/app_theme.dart';

/// Simple wrapper widget for creating the App
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: ChemicalInventoryApp());
  }
}

class ChemicalInventoryApp extends ConsumerWidget {
  const ChemicalInventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppEnvironment.current.appTitle,
      debugShowCheckedModeBanner: false,
      // Light theme
      theme: AppTheme.light(),
      // Dark theme
      darkTheme: AppTheme.dark(),
      // Use system theme mode (auto switch)
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
