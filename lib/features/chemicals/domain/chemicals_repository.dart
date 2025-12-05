import 'chemical.dart';

abstract class ChemicalsRepository {
  Future<List<Chemical>> fetchChemicals();
}
