// lib/core/config/supabase_config.dart
//
// Supabase client initialization.
// ⚠️  IMPORTANT: Replace the placeholder values below with your actual
//     Supabase project credentials BEFORE running the app.
//     Never commit real credentials to version control.
//
// Steps to get your credentials:
//   1. Go to https://supabase.com and open your project dashboard.
//   2. Navigate to Project Settings → API.
//   3. Copy "Project URL" → paste as SUPABASE_URL.
//   4. Copy "anon / public" key → paste as SUPABASE_ANON_KEY.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Initializes the Supabase client.
///
/// Call this once at the top of [main] before [runApp].
/// After initialization, access the client anywhere via [Supabase.instance.client].
Future<void> initSupabase() async {
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    throw Exception('Missing Supabase credentials in .env file.');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey, // ignore: deprecated_member_use
    // TODO: Update to `publishableKey` once upgrading supabase_flutter to next major version.
  );
}

/// Convenience getter for the initialized Supabase client.
SupabaseClient get supabase => Supabase.instance.client;
