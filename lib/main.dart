import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

import 'src/app.dart';
import 'src/features/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Load the settings (user's preferred theme) while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await di.sl<SettingsController>().loadSettings();

  runApp(const MyApp());
}
