import 'package:flutter/foundation.dart';

import '../domain/chemicals_repository.dart';
import 'chemicals_state.dart';

class ChemicalsNotifier extends ValueNotifier<ChemicalsState> {
  ChemicalsNotifier(this._repository) : super(ChemicalsState.loading());

  final ChemicalsRepository _repository;

  Future<void> loadChemicals() async {
    value = ChemicalsState.loading();
    await _fetchAndUpdate();
  }

  Future<void> refresh() async {
    await _fetchAndUpdate();
  }

  Future<void> _fetchAndUpdate() async {
    try {
      final response = await _repository.fetchChemicals();
      value = ChemicalsState.success(response.chemicals, response.metrics);
    } catch (error) {
      value = ChemicalsState.error(error.toString());
    }
  }
}
