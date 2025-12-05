import 'dart:math';

import '../domain/chemical.dart';
import '../domain/chemicals_repository.dart';
import '../domain/dashboard_metrics.dart';

class MockChemicalsRepository implements ChemicalsRepository {
  MockChemicalsRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  Future<ChemicalsApiResponse> fetchChemicals() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Randomly throw to emulate flaky networks.
    if (_random.nextInt(8) == 0) {
      throw Exception('Network error');
    }

    const chemicals = <Chemical>[
      Chemical(
        id: 'MOCK001',
        productName: 'Sodium Chloride',
        casNumber: '7647-14-5',
        manufacturer: 'NeoTech Labs',
        stockQuantity: 120.0,
        unit: 'kg',
      ),
      Chemical(
        id: 'MOCK002',
        productName: 'Acetic Acid',
        casNumber: '64-19-7',
        manufacturer: 'Universal Reagents',
        stockQuantity: 75.5,
        unit: 'L',
      ),
      Chemical(
        id: 'MOCK003',
        productName: 'Ethanol',
        casNumber: '64-17-5',
        manufacturer: 'BioChem Co.',
        stockQuantity: 240.0,
        unit: 'L',
      ),
    ];

    const metrics = DashboardMetrics(
      totalChemicals: 3,
      activeSDSDocuments: 3,
      recentIncidents: 0,
    );

    return const ChemicalsApiResponse(
      chemicals: chemicals,
      metrics: metrics,
    );
  }
}
