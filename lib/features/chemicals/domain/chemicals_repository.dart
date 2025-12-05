import 'chemical.dart';
import 'dashboard_metrics.dart';

/// Response containing chemicals list and dashboard metrics.
class ChemicalsApiResponse {
  const ChemicalsApiResponse({
    required this.chemicals,
    required this.metrics,
  });

  final List<Chemical> chemicals;
  final DashboardMetrics metrics;
}

/// Repository interface for fetching chemicals data.
abstract class ChemicalsRepository {
  Future<ChemicalsApiResponse> fetchChemicals();
}
