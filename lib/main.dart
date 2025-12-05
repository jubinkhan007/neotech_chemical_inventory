import 'package:flutter/material.dart';
import 'package:neotech_chemical_inventory/features/data_entry/presentation/data_entry_screen.dart';

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
      ),
      home: const DataEntryScreen(),
    );
  }
}
