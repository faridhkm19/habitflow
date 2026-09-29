// lib/main.dart
//
// Application entry point.
// Initializes Supabase before starting the Flutter widget tree.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/supabase_config.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/preferences_service.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before calling native code
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase client (credentials in core/config/supabase_config.dart)
  await initSupabase();

  // Initialize locale data for id_ID (needed for DateFormat)
  await initializeDateFormatting('id_ID', null);

  // Initialize Services
  await PreferencesService.instance.initialize();

  runApp(
    // ProviderScope is the root Riverpod container — required for all providers
    const ProviderScope(child: HabitFlowApp()),
  );
}
