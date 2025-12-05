import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/ui/app_spacing.dart';
import '../../chemicals/data/chemicals_repository.dart';
import '../../chemicals/domain/chemicals_repository.dart';
import '../../chemicals/domain/dashboard_metrics.dart';
import '../../chemicals/presentation/chemicals_notifier.dart';
import '../../chemicals/presentation/chemicals_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ChemicalsNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ChemicalsNotifier(ChemicalsRepositoryImpl())..loadChemicals();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Inventory'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ChemicalsState>(
          valueListenable: _notifier,
          builder: (context, state, _) {
            return RefreshIndicator(
              onRefresh: _notifier.refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Metrics Section
                    Text(
                      'Dashboard Overview',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildMetricsSection(state, colorScheme, textTheme),
                    const SizedBox(height: AppSpacing.xl),

                    // Quick Actions Section
                    Text(
                      'Quick Actions',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildQuickActions(context, colorScheme),
                    const SizedBox(height: AppSpacing.xl),

                    // Recent Activity Section
                    Text(
                      'Recent Activity',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildRecentActivity(colorScheme, textTheme),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricsSection(
    ChemicalsState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    if (state.status == ChemicalsStatus.loading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == ChemicalsStatus.error) {
      return Card(
        color: colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Failed to load metrics. Pull to refresh.',
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final metrics = state.metrics ??
        DashboardMetrics(
          totalChemicals: state.chemicals.length,
          activeSDSDocuments: state.chemicals.length,
          recentIncidents: 0,
        );

    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.science_outlined,
            label: 'Total Chemicals',
            value: '${metrics.totalChemicals}',
            color: colorScheme.primary,
            backgroundColor: colorScheme.primaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricCard(
            icon: Icons.description_outlined,
            label: 'Active SDS',
            value: '${metrics.activeSDSDocuments}',
            color: colorScheme.secondary,
            backgroundColor: colorScheme.secondaryContainer,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MetricCard(
            icon: Icons.warning_amber_outlined,
            label: 'Incidents',
            value: '${metrics.recentIncidents}',
            color: colorScheme.tertiary,
            backgroundColor: colorScheme.tertiaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ColorScheme colorScheme) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        _ActionButton(
          icon: Icons.list_alt_outlined,
          label: 'View Chemicals',
          onPressed: () => context.pushNamed(AppRoutes.chemicals.name),
          colorScheme: colorScheme,
        ),
        _ActionButton(
          icon: Icons.camera_alt_outlined,
          label: 'Scan Label',
          onPressed: () => context.pushNamed(AppRoutes.camera.name),
          colorScheme: colorScheme,
        ),
        _ActionButton(
          icon: Icons.note_add_outlined,
          label: 'Add Entry',
          onPressed: () => context.pushNamed(AppRoutes.dataEntry.name),
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.history,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'No recent activity',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start by viewing the chemicals list or scanning a label.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.colorScheme,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
