import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/presentation/screens/guided_setup_screen.dart';
import '../../features/logging/presentation/screens/home_screen.dart';
import '../../features/habits/presentation/screens/habits_list_screen.dart';
import '../../features/habits/presentation/screens/add_habit_screen.dart';
import '../../features/habits/presentation/screens/edit_habit_screen.dart';
import '../../features/habits/presentation/screens/habit_detail_screen.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/security_screen.dart';
import '../../features/profile/presentation/screens/achievements_screen.dart';
import '../../features/logging/presentation/screens/habit_journal_screen.dart';
import '../../shared/layout/mobile_scaffold.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const guidedSetup = '/onboarding/guided-setup';
  static const home = '/home';
  static const habits = '/habits';
  static const addHabit = '/habits/add';
  static const statistics = '/statistics';
  static const profile = '/profile';
}

const _publicRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

GoRouter createAppRouter(Ref ref) {
  // RouterNotifier memungkinkan GoRouter refresh otomatis saat authState/habitState berubah
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      final location = state.matchedLocation;

      // Auth masih loading → tampilkan splash
      if (authAsync.isLoading) return AppRoutes.splash;

      final isLoggedIn = authAsync.value != null;
      final isPublicRoute = _publicRoutes.contains(location);

      // --- Belum Login ---
      if (!isLoggedIn) {
        if (location == AppRoutes.splash) return AppRoutes.login;
        if (!isPublicRoute) return AppRoutes.login;
        return null;
      }

      // --- Sudah Login ---

      // Baca flag is_onboarded dari tabel profiles.
      // Ini menggantikan logika lama yang mengecek jumlah habit (userHasHabitsProvider),
      // yang rawan bug jika user lama menghapus semua habitnya.
      final isOnboardedAsync = ref.read(isOnboardedProvider);

      // Data profil masih ditarik → tampilkan splash (buffer)
      if (isOnboardedAsync.isLoading) return AppRoutes.splash;

      final isOnboarded = isOnboardedAsync.value ?? false;

      // 1. User belum onboarding (baru sign up) → paksa ke guided setup
      if (!isOnboarded && location != AppRoutes.guidedSetup) {
        return AppRoutes.guidedSetup;
      }

      // 2. User sudah onboarding → jangan biarkan kembali ke halaman auth/onboarding
      if (isOnboarded && (isPublicRoute || location == AppRoutes.guidedSetup || location == AppRoutes.splash)) {
        return AppRoutes.home;
      }

      return null; // biarkan jalan
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.guidedSetup, builder: (context, state) => const GuidedSetupScreen()),
      ShellRoute(
        builder: (context, state, child) => MobileScaffold(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: AppRoutes.habits,
            builder: (context, state) => const HabitsListScreen(),
            routes: [
              GoRoute(path: 'add', builder: (context, state) => const AddHabitScreen()),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final habit = state.extra as HabitEntity;
                  return HabitDetailScreen(habit: habit);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final habit = state.extra as HabitEntity;
                      return EditHabitScreen(habit: habit);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.statistics,
            builder: (context, state) => const StatisticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'security',
                builder: (context, state) => const SecurityScreen(),
              ),
              GoRoute(
                path: 'journal',
                builder: (context, state) => const HabitJournalScreen(),
              ),
              GoRoute(
                path: 'achievements',
                builder: (context, state) => const AchievementsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// ChangeNotifier yang mendengarkan authStateProvider & isOnboardedProvider
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authStateProvider, (prev, next) => notifyListeners());
    ref.listen(isOnboardedProvider, (prev, next) => notifyListeners());
  }
}
