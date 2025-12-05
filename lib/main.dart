import 'package:flutter/material.dart';

import 'features/chemicals/data/mock_chemicals_repository.dart';
import 'features/chemicals/domain/chemicals_repository.dart';
import 'features/chemicals/presentation/chemicals_screen.dart';
import 'features/common/widgets/repository_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockChemicalsRepository();

    return RepositoryProvider<ChemicalsRepository>(
      repository: repository,
      child: MaterialApp(
        title: 'Chemical Inventory',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ChemicalsScreen(),
      ),
    );
  }
}
