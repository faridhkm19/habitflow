import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/presentation/screens/guided_setup_screen.dart';
import '../../features/logging/presentation/screens/home_screen.dart';
import '../../features/habits/presentation/providers/habit_provider.dart';
import '../../features/habits/presentation/screens/habits_list_screen.dart';
import '../../features/habits/presentation/screens/add_habit_screen.dart';
import '../../features/habits/presentation/screens/edit_habit_screen.dart';
import '../../features/habits/presentation/screens/habit_detail_screen.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import '../../features/statistics/presentation/screens/statistics_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared/layout/adaptive_scaffold.dart';

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
      
      // Ambil status apakah user punya habit (untuk route guard onboarding)
      final hasHabitsAsync = ref.read(userHasHabitsProvider);
      
      // Data habit masih ditarik → tampilkan splash (buffer)
      if (hasHabitsAsync.isLoading) return AppRoutes.splash;

      final hasHabits = hasHabitsAsync.value ?? false;

      // 1. User belum punya habit, tapi mencoba masuk selain ke halaman onboarding
      if (!hasHabits && location != AppRoutes.guidedSetup) {
        return AppRoutes.guidedSetup;
      }

      // 2. User sudah punya habit, tapi malah buka public route atau onboarding lagi
      if (hasHabits && (isPublicRoute || location == AppRoutes.guidedSetup || location == AppRoutes.splash)) {
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
        builder: (context, state, child) => AdaptiveScaffold(child: child),
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
              ),
              GoRoute(
                path: ':id/edit',
                builder: (context, state) {
                  final habit = state.extra as HabitEntity;
                  return EditHabitScreen(habit: habit);
                },
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
          ),
        ],
      ),
    ],
  );
}

// ChangeNotifier yang mendengarkan authStateProvider & userHasHabitsProvider
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authStateProvider, (prev, next) => notifyListeners());
    ref.listen(userHasHabitsProvider, (prev, next) => notifyListeners());
  }
}
