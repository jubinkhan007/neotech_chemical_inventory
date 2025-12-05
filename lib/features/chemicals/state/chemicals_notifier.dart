import 'package:flutter/foundation.dart';

import '../data/chemicals_repository.dart';
import '../domain/chemical.dart';
import '../domain/chemicals_repository.dart';
import '../domain/dashboard_metrics.dart';

abstract class ChemicalsState {
  const ChemicalsState();
}

class ChemicalsLoading extends ChemicalsState {
  const ChemicalsLoading();
}

class ChemicalsError extends ChemicalsState {
  const ChemicalsError(this.message);

  final String message;
}

class ChemicalsEmpty extends ChemicalsState {
  const ChemicalsEmpty();
}

class ChemicalsLoaded extends ChemicalsState {
  const ChemicalsLoaded(this.chemicals, this.metrics);

  final List<Chemical> chemicals;
  final DashboardMetrics metrics;
}

class ChemicalsNotifier extends ChangeNotifier {
  ChemicalsNotifier({ChemicalsRepository? repository})
      : _repository = repository ?? ChemicalsRepositoryImpl(),
        _state = const ChemicalsLoading();

  final ChemicalsRepository _repository;
  ChemicalsState _state;

  ChemicalsState get state => _state;

  Future<void> loadChemicals() async {
    _state = const ChemicalsLoading();
    notifyListeners();

    try {
      final response = await _repository.fetchChemicals();
      if (response.chemicals.isEmpty) {
        _state = const ChemicalsEmpty();
      } else {
        _state = ChemicalsLoaded(response.chemicals, response.metrics);
      }
    } on Exception catch (error) {
      _state = ChemicalsError(error.toString());
    }

    notifyListeners();
  }
}
