import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chemical Inventory',
      themeMode: ThemeMode.system,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: const InventoryHomePage(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2D6A4F),
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: brightness == Brightness.dark
        ? const Color(0xFF0F1A14)
        : const Color(0xFFF7F9F5),
    cardTheme: CardTheme(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: Typography.material2021().black.apply(
          bodyColor: brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class InventoryHomePage extends StatelessWidget {
  const InventoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chemicals = _sampleChemicals;
    final lowStockChemicals = chemicals.where((c) => c.isLowStock).toList();
    final alerts = chemicals.where((c) => c.hasAlert).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemical Inventory'),
        centerTitle: true,
      ),
      floatingActionButton: Semantics(
        label: 'Add new chemical',
        button: true,
        child: FloatingActionButton(
          tooltip: 'Add chemical',
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 900
                ? 48.0
                : constraints.maxWidth > 600
                    ? 32.0
                    : 16.0;

            return Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _HeaderSection(),
                    const SizedBox(height: 12),
                    _MetricRow(
                      metrics: [
                        _MetricCardData(
                          label: 'Total chemicals',
                          value: chemicals.length.toString(),
                          icon: Icons.inventory_2_outlined,
                        ),
                        _MetricCardData(
                          label: 'Low stock',
                          value: lowStockChemicals.length.toString(),
                          icon: Icons.warning_amber_rounded,
                          tone: MetricTone.warning,
                        ),
                        _MetricCardData(
                          label: 'Active alerts',
                          value: alerts.length.toString(),
                          icon: Icons.error_outline,
                          tone: MetricTone.danger,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Inventory overview',
                      subtitle:
                          'Monitor capacity, hazard class, and storage conditions.',
                      child: Column(
                        children: chemicals
                            .map((chemical) => _ChemicalCard(chemical: chemical))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Alerts & actions',
                      subtitle: alerts.isEmpty
                          ? 'Everything looks stable today.'
                          : 'Review issues to keep the lab compliant.',
                      child: alerts.isEmpty
                          ? const _EmptyState(
                              icon: Icons.shield_moon_outlined,
                              title: 'No active alerts',
                              message:
                                  'All storage conditions are within safe ranges.',
                            )
                          : Column(
                              children: alerts
                                  .map((alert) => _AlertTile(chemical: alert))
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Receiving queue',
                      subtitle:
                          'Track incoming shipments and schedule quality checks.',
                      child: const _EmptyState(
                        icon: Icons.move_to_inbox_outlined,
                        title: 'No incoming deliveries',
                        message:
                            'Schedule your next shipment to keep the shelves stocked.',
                        isError: false,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lab readiness',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Consistent spacing, adaptive layout, and accessible controls keep the inventory easy to navigate.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.metrics});

  final List<_MetricCardData> metrics;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final crossAxisCount = isWide ? 3 : 1;
    final spacing = isWide ? 12.0 : 10.0;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: isWide ? 2.6 : 2.8,
      ),
      itemBuilder: (context, index) {
        return _MetricCard(data: metrics[index]);
      },
    );
  }
}

enum MetricTone { neutral, warning, danger }

class _MetricCardData {
  const _MetricCardData({
    required this.label,
    required this.value,
    required this.icon,
    this.tone = MetricTone.neutral,
  });

  final String label;
  final String value;
  final IconData icon;
  final MetricTone tone;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final Color toneColor;

    switch (data.tone) {
      case MetricTone.warning:
        toneColor = colorScheme.tertiary;
        break;
      case MetricTone.danger:
        toneColor = colorScheme.error;
        break;
      case MetricTone.neutral:
      default:
        toneColor = colorScheme.primary;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  data.value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: toneColor,
                  ),
                ),
              ],
            ),
            Icon(
              data.icon,
              color: toneColor,
              size: 28,
              semanticLabel: data.label,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Semantics(
                  image: true,
                  label: '$title icon',
                  child: Icon(
                    Icons.spa_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ChemicalCard extends StatelessWidget {
  const _ChemicalCard({required this.chemical});

  final Chemical chemical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = Theme.of(context).cardTheme.color;
    final statusColor = chemical.isLowStock
        ? colorScheme.tertiary
        : colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surfaceColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: kElevationToShadow[1],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Semantics(
              image: true,
              label: '${chemical.name} container icon',
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.science_outlined,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chemical.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${chemical.location} • Hazard: ${chemical.hazard}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: chemical.stockLevel,
                    semanticsLabel: '${chemical.name} fill level',
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _StatusChip(
                        label: '${(chemical.stockLevel * 100).round()}% full',
                        icon: Icons.local_shipping_outlined,
                      ),
                      _StatusChip(
                        label: 'Temp: ${chemical.temperature}°C',
                        icon: Icons.thermostat,
                      ),
                      _StatusChip(
                        label: 'Ventilation: ${chemical.ventilation}',
                        icon: Icons.air_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    chemical.isLowStock ? 'Low stock' : 'Stable',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'View details',
                      icon: const Icon(Icons.visibility_outlined),
                      onPressed: () {},
                      semanticLabel: 'View ${chemical.name} details',
                    ),
                    IconButton(
                      tooltip: 'Restock',
                      icon: const Icon(Icons.add_box_outlined),
                      onPressed: () {},
                      semanticLabel: 'Restock ${chemical.name}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 18, semanticLabel: label),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.chemical});

  final Chemical chemical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      leading: Semantics(
        image: true,
        label: '${chemical.name} alert icon',
        child: CircleAvatar(
          backgroundColor: colorScheme.error.withOpacity(0.15),
          child: Icon(
            Icons.error_outline,
            color: colorScheme.error,
          ),
        ),
      ),
      title: Text(
        '${chemical.name} is low in storage',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        'Only ${(chemical.stockLevel * 100).round()}% remains. Confirm supplier ETA and move to ventilated shelf.',
      ),
      trailing: Semantics(
        button: true,
        label: 'Acknowledge alert for ${chemical.name}',
        child: TextButton(
          onPressed: () {},
          child: const Text('Acknowledge'),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isError
        ? theme.colorScheme.error
        : theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Semantics(
            image: true,
            label: '$title illustration',
            child: Icon(
              icon,
              size: 56,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Chemical {
  const Chemical({
    required this.name,
    required this.location,
    required this.hazard,
    required this.stockLevel,
    required this.temperature,
    required this.ventilation,
    this.hasAlert = false,
  });

  final String name;
  final String location;
  final String hazard;
  final double stockLevel; // 0.0 - 1.0
  final double temperature;
  final String ventilation;
  final bool hasAlert;

  bool get isLowStock => stockLevel < 0.35;
}

const _sampleChemicals = [
  Chemical(
    name: 'Acetone',
    location: 'Cabinet A3',
    hazard: 'Flammable',
    stockLevel: 0.28,
    temperature: 22,
    ventilation: 'Required',
    hasAlert: true,
  ),
  Chemical(
    name: 'Hydrochloric Acid',
    location: 'Cabinet B1',
    hazard: 'Corrosive',
    stockLevel: 0.62,
    temperature: 20,
    ventilation: 'Required',
  ),
  Chemical(
    name: 'Sodium Hydroxide',
    location: 'Cabinet C2',
    hazard: 'Caustic',
    stockLevel: 0.44,
    temperature: 21,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ethanol',
    location: 'Cold Storage',
    hazard: 'Flammable',
    stockLevel: 0.82,
    temperature: 4,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ammonia Solution',
    location: 'Ventilated Shelf',
    hazard: 'Toxic',
    stockLevel: 0.31,
    temperature: 19,
    ventilation: 'Required',
    hasAlert: true,
  ),
];
