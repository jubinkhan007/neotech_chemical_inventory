import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.init(AppFlavor.production);
  runApp(const ProviderScope(child: ChemicalInventoryApp()));
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

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.valueKey,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Key valueKey;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '$value',
                  key: valueKey,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
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
