import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/services/preferences_service.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  ThemeMode _parseThemeMode(String mode) {
    if (mode == 'dark') return ThemeMode.dark;
    if (mode == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  @override
  ThemeMode build() {
    // Sync with remote data when loaded
    ref.listen(profileDataProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final profileTheme = next.value!.themePreference;
        if (PreferencesService.instance.themePreference != profileTheme) {
          PreferencesService.instance.setThemePreference(profileTheme);
          state = _parseThemeMode(profileTheme);
        }
      }
    });

    // Set default theme from local cache synchronously
    final cachedPref = PreferencesService.instance.themePreference;
    return _parseThemeMode(cachedPref);
  }

  Future<void> setTheme(String pref) async {
    // Update local state for immediate feedback
    state = _parseThemeMode(pref);
    await PreferencesService.instance.setThemePreference(pref);

    // Save to Supabase
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      final usecase = ref.read(updateThemePreferenceUseCaseProvider);
      await usecase(user.id, pref);

      // Invalidate profile so next fetch gets updated data
      ref.invalidate(profileDataProvider);
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
