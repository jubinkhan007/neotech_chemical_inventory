import 'package:flutter/foundation.dart';

import '../data/chemicals_repository.dart';
import '../models/chemical.dart';

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
  const ChemicalsLoaded(this.chemicals);

  final List<Chemical> chemicals;
}

class ChemicalsNotifier extends ChangeNotifier {
  ChemicalsNotifier({required ChemicalsRepository repository})
      : _repository = repository,
        _state = const ChemicalsLoading();

  final ChemicalsRepository _repository;
  ChemicalsState _state;

  ChemicalsState get state => _state;

  Future<void> loadChemicals() async {
    _state = const ChemicalsLoading();
    notifyListeners();

    try {
      final chemicals = await _repository.fetchChemicals();
      if (chemicals.isEmpty) {
        _state = const ChemicalsEmpty();
      } else {
        _state = ChemicalsLoaded(chemicals);
      }
    } on Exception catch (error) {
      _state = ChemicalsError(error.toString());
    }

    notifyListeners();
  }
}
