import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local caching
  await Hive.initFlutter();
  
  // Initialize app environment
  AppEnvironment.init(AppFlavor.production);
  
  runApp(const ProviderScope(child: ChemicalInventoryApp()));
}
