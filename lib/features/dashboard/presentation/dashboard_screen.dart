import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_environment.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/app_spacing.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(
              child: Text(
                AppEnvironment.current.isDevelopment ? 'DEV' : 'PROD',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chemical Inventory',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Quick links',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRoutes.camera.name),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Open Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRoutes.dataEntry.name),
                  icon: const Icon(Icons.note_add_outlined),
                  label: const Text('Data Entry'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Recent activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('No recent activity yet.'),
                    SizedBox(height: AppSpacing.sm),
                    Text('Add a chemical record to get started.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
