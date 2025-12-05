import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neotech Chemical Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Inventory Dashboard'),
    );
  }
}

class ChemicalRecord {
  const ChemicalRecord({
    required this.name,
    required this.containers,
    required this.hasSds,
    required this.incidents,
    required this.location,
  });

  final String name;
  final int containers;
  final bool hasSds;
  final int incidents;
  final String location;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ChemicalRecord> _chemicals = const [
    ChemicalRecord(
      name: 'Acetone',
      containers: 3,
      hasSds: true,
      incidents: 1,
      location: 'Flammable Cabinet',
    ),
    ChemicalRecord(
      name: 'Hydrochloric Acid',
      containers: 2,
      hasSds: true,
      incidents: 0,
      location: 'Corrosives Cabinet',
    ),
    ChemicalRecord(
      name: 'Sodium Hydroxide',
      containers: 4,
      hasSds: false,
      incidents: 0,
      location: 'Corrosives Cabinet',
    ),
    ChemicalRecord(
      name: 'Ethanol',
      containers: 5,
      hasSds: true,
      incidents: 2,
      location: 'Flammable Cabinet',
    ),
    ChemicalRecord(
      name: 'Ammonia',
      containers: 1,
      hasSds: false,
      incidents: 0,
      location: 'Ventilated Storage',
    ),
  ];

  int get totalChemicals => _chemicals.length;

  int get availableSds => _chemicals.where((chemical) => chemical.hasSds).length;

  int get incidentsReported =>
      _chemicals.fold(0, (count, chemical) => count + chemical.incidents);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: DashboardSummary(
                totalChemicals: totalChemicals,
                sdsAvailable: availableSds,
                incidentsReported: incidentsReported,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList.builder(
              itemCount: _chemicals.length,
              itemBuilder: (context, index) {
                final chemical = _chemicals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      child: Text(chemical.name.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(
                      chemical.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text('${chemical.containers} containers • ${chemical.location}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              chemical.hasSds ? Icons.check_circle : Icons.error_outline,
                              color: chemical.hasSds
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.error,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(chemical.hasSds ? 'SDS' : 'Missing'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${chemical.incidents} incidents',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({
    super.key,
    required this.totalChemicals,
    required this.sdsAvailable,
    required this.incidentsReported,
  });

  final int totalChemicals;
  final int sdsAvailable;
  final int incidentsReported;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Summary',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final bool useRowLayout = constraints.maxWidth > 600;
                final children = [
                  _SummaryTile(
                    key: const Key('totalChemicalsTile'),
                    label: 'Total chemicals',
                    value: totalChemicals,
                    icon: Icons.inventory_2,
                    color: colors.primary,
                    valueKey: const Key('totalChemicalsValue'),
                  ),
                  _SummaryTile(
                    key: const Key('sdsTile'),
                    label: 'SDS available',
                    value: sdsAvailable,
                    icon: Icons.description_outlined,
                    color: colors.tertiary,
                    valueKey: const Key('sdsValue'),
                  ),
                  _SummaryTile(
                    key: const Key('incidentsTile'),
                    label: 'Incidents reported',
                    value: incidentsReported,
                    icon: Icons.warning_amber_rounded,
                    color: colors.error,
                    valueKey: const Key('incidentsValue'),
                  ),
                ];

                if (useRowLayout) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children
                        .map(
                          (child) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: child,
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                final double tileWidth = constraints.maxWidth >= 500
                    ? (constraints.maxWidth - 8) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: children
                      .map(
                        (child) => SizedBox(
                          width: tileWidth,
                          child: child,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
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
