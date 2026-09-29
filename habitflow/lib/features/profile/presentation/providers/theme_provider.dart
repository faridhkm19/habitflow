import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // Watch profile data
    final profileAsync = ref.watch(profileDataProvider);
    
    // Set default theme as light
    ThemeMode mode = ThemeMode.light;
    
    profileAsync.whenData((profile) {
      if (profile != null) {
        mode = profile.themePreference == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    });
    
    return mode;
  }

  Future<void> toggleTheme(bool isDark) async {
    // Update local state for immediate feedback
    state = isDark ? ThemeMode.dark : ThemeMode.light;
    
    // Save to Supabase
    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      final usecase = ref.read(updateThemePreferenceUseCaseProvider);
      final pref = isDark ? 'dark' : 'light';
      await usecase(user.id, pref);
      
      // Invalidate profile so next fetch gets updated data
      ref.invalidate(profileDataProvider);
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
