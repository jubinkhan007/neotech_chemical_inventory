import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/config/app_environment.dart';
import 'core/router/app_router.dart';
import 'core/ui/app_theme.dart';

class ChemicalInventoryApp extends ConsumerWidget {
  const ChemicalInventoryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppEnvironment.current.appTitle,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
