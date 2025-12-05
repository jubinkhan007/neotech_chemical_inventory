import 'package:flutter/material.dart';

import '../../../core/ui/app_spacing.dart';
import '../data/chemicals_repository.dart';
import '../domain/chemical.dart';
import '../presentation/chemicals_notifier.dart';
import '../presentation/chemicals_state.dart';

class ChemicalsScreen extends StatefulWidget {
  const ChemicalsScreen({super.key});

  @override
  State<ChemicalsScreen> createState() => _ChemicalsScreenState();
}

class _ChemicalsScreenState extends State<ChemicalsScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemicals List'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ChemicalsState>(
          valueListenable: _notifier,
          builder: (context, state, _) {
            switch (state.status) {
              case ChemicalsStatus.loading:
                return _LoadingSection(colorScheme: colorScheme);
              case ChemicalsStatus.error:
                return _ErrorSection(
                  colorScheme: colorScheme,
                  onRetry: _notifier.loadChemicals,
                  message: state.errorMessage ?? 'Unable to load chemicals.',
                );
              case ChemicalsStatus.empty:
                return const _EmptySection();
              case ChemicalsStatus.success:
                return RefreshIndicator(
                  onRefresh: _notifier.refresh,
                  color: colorScheme.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: state.chemicals.length,
                    itemBuilder: (context, index) {
                      final chemical = state.chemicals[index];
                      return _ChemicalCard(
                        chemical: chemical,
                        colorScheme: colorScheme,
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Loading chemical inventory',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Loading chemicals...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection({
    required this.colorScheme,
    required this.onRetry,
    required this.message,
  });

  final ColorScheme colorScheme;
  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Error loading chemical inventory',
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_rounded, color: colorScheme.error, size: 48),
              const SizedBox(height: 12),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Semantics(
        label: 'No chemicals in inventory',
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'No chemicals available',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pull to refresh or check back later.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChemicalCard extends StatelessWidget {
  const _ChemicalCard({required this.chemical, required this.colorScheme});

  final Chemical chemical;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardColor = colorScheme.surfaceContainerHighest;
    final onCardColor = colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Semantics(
        label:
            '${chemical.productName}, CAS ${chemical.casNumber}, ${chemical.manufacturer}, Stock ${chemical.stockQuantity} ${chemical.unit}',
        child: Card(
          elevation: 0,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chemical.productName,
                  style: textTheme.titleMedium?.copyWith(
                    color: onCardColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  label: 'CAS Number',
                  value: chemical.casNumber,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                _DetailRow(
                  label: 'Manufacturer',
                  value: chemical.manufacturer,
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
                _DetailRow(
                  label: 'Stock',
                  value:
                      '${chemical.stockQuantity.toStringAsFixed(1)} ${chemical.unit}',
                  textTheme: textTheme,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
