import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/ui/app_spacing.dart';
import '../data/cached_chemicals_repository.dart';
import '../data/chemical_cache.dart';
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
  late final CachedChemicalsRepository _repository;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _repository = CachedChemicalsRepository();
    _initRepository();
  }

  Future<void> _initRepository() async {
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChemicalCacheAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DashboardMetricsCacheAdapter());
    }
    await _repository.init();
    _notifier = ChemicalsNotifier(_repository)..loadChemicals();
    if (mounted) setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    if (_isInitialized) _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chemicals List')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                  child: _AnimatedChemicalList(
                    chemicals: state.chemicals,
                    colorScheme: colorScheme,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

/// Animated list that staggers the appearance of list items
class _AnimatedChemicalList extends StatefulWidget {
  const _AnimatedChemicalList({
    required this.chemicals,
    required this.colorScheme,
  });

  final List<Chemical> chemicals;
  final ColorScheme colorScheme;

  @override
  State<_AnimatedChemicalList> createState() => _AnimatedChemicalListState();
}

class _AnimatedChemicalListState extends State<_AnimatedChemicalList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.chemicals.length * 100)),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: widget.chemicals.length,
      itemBuilder: (context, index) {
        final chemical = widget.chemicals[index];
        final delay = index / widget.chemicals.length;
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            delay * 0.5,
            delay * 0.5 + 0.5,
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.2, 0),
              end: Offset.zero,
            ).animate(animation),
            child: _ChemicalCard(
              chemical: chemical,
              colorScheme: widget.colorScheme,
            ),
          ),
        );
      },
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
