import '../domain/chemical.dart';
import '../domain/dashboard_metrics.dart';

enum ChemicalsStatus { loading, success, empty, error }

class ChemicalsState {
  const ChemicalsState({
    required this.status,
    required this.chemicals,
    this.metrics,
    this.errorMessage,
  });

  factory ChemicalsState.loading() => const ChemicalsState(
        status: ChemicalsStatus.loading,
        chemicals: <Chemical>[],
      );

  factory ChemicalsState.success(
    List<Chemical> chemicals,
    DashboardMetrics metrics,
  ) {
    return ChemicalsState(
      status: chemicals.isEmpty ? ChemicalsStatus.empty : ChemicalsStatus.success,
      chemicals: chemicals,
      metrics: metrics,
    );
  }

  factory ChemicalsState.error(String message) => ChemicalsState(
        status: ChemicalsStatus.error,
        chemicals: const <Chemical>[],
        errorMessage: message,
      );

  final ChemicalsStatus status;
  final List<Chemical> chemicals;
  final DashboardMetrics? metrics;
  final String? errorMessage;
}
