import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/camera/presentation/camera_screen.dart';
import '../../features/chemicals/presentation/chemicals_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/data_entry/presentation/data_entry_screen.dart';

class AppRoute {
  const AppRoute({required this.name, required this.path});

  final String name;
  final String path;
}

class AppRoutes {
  const AppRoutes._();

  static const dashboard = AppRoute(name: 'dashboard', path: '/');
  static const chemicals = AppRoute(name: 'chemicals', path: '/chemicals');
  static const camera = AppRoute(name: 'camera', path: '/camera');
  static const dataEntry = AppRoute(name: 'data-entry', path: '/data-entry');
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard.path,
    routes: <RouteBase>[
      GoRoute(
        name: AppRoutes.dashboard.name,
        path: AppRoutes.dashboard.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: DashboardScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.chemicals.name,
        path: AppRoutes.chemicals.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: ChemicalsScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.camera.name,
        path: AppRoutes.camera.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: CameraScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.dataEntry.name,
        path: AppRoutes.dataEntry.path,
        pageBuilder: (context, state) => const MaterialPage(
          child: DataEntryScreen(),
        ),
      ),
    ],
  );
});
