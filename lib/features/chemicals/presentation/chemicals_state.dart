import '../domain/chemical.dart';

enum ChemicalsStatus { loading, success, empty, error }

class ChemicalsState {
  const ChemicalsState({
    required this.status,
    required this.chemicals,
    this.errorMessage,
  });

  factory ChemicalsState.loading() => const ChemicalsState(
        status: ChemicalsStatus.loading,
        chemicals: <Chemical>[],
      );

  factory ChemicalsState.success(List<Chemical> chemicals) {
    return ChemicalsState(
      status: chemicals.isEmpty ? ChemicalsStatus.empty : ChemicalsStatus.success,
      chemicals: chemicals,
    );
  }

  factory ChemicalsState.error(String message) => ChemicalsState(
        status: ChemicalsStatus.error,
        chemicals: const <Chemical>[],
        errorMessage: message,
      );

  final ChemicalsStatus status;
  final List<Chemical> chemicals;
  final String? errorMessage;
}
