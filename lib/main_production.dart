import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/config/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.init(AppFlavor.production);
  runApp(const ProviderScope(child: ChemicalInventoryApp()));
}
