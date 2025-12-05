import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:neotech_chemical_inventory/features/data_entry/presentation/data_entry_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.init(AppFlavor.production);
  runApp(const ProviderScope(child: ChemicalInventoryApp()));
}

class _ChemicalCard extends StatelessWidget {
  const _ChemicalCard({required this.chemical});

  final Chemical chemical;

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

class Chemical {
  const Chemical({
    required this.name,
    required this.location,
    required this.hazard,
    required this.stockLevel,
    required this.temperature,
    required this.ventilation,
    this.hasAlert = false,
  });

  final String name;
  final String location;
  final String hazard;
  final double stockLevel; // 0.0 - 1.0
  final double temperature;
  final String ventilation;
  final bool hasAlert;

  bool get isLowStock => stockLevel < 0.35;
}

const _sampleChemicals = [
  Chemical(
    name: 'Acetone',
    location: 'Cabinet A3',
    hazard: 'Flammable',
    stockLevel: 0.28,
    temperature: 22,
    ventilation: 'Required',
    hasAlert: true,
  ),
  Chemical(
    name: 'Hydrochloric Acid',
    location: 'Cabinet B1',
    hazard: 'Corrosive',
    stockLevel: 0.62,
    temperature: 20,
    ventilation: 'Required',
  ),
  Chemical(
    name: 'Sodium Hydroxide',
    location: 'Cabinet C2',
    hazard: 'Caustic',
    stockLevel: 0.44,
    temperature: 21,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ethanol',
    location: 'Cold Storage',
    hazard: 'Flammable',
    stockLevel: 0.82,
    temperature: 4,
    ventilation: 'Recommended',
  ),
  Chemical(
    name: 'Ammonia Solution',
    location: 'Ventilated Shelf',
    hazard: 'Toxic',
    stockLevel: 0.31,
    temperature: 19,
    ventilation: 'Required',
    hasAlert: true,
  ),
];
