// lib/features/auth/presentation/providers/auth_provider.dart
//
// Riverpod providers untuk modul autentikasi.
//
// Struktur provider (dari bawah ke atas):
//   authRemoteDataSourceProvider  →  AuthRemoteDataSourceImpl
//   authRepositoryProvider        →  AuthRepositoryImpl (inject datasource)
//   signUpUseCaseProvider         →  SignUpUseCase (inject repository)
//   signInUseCaseProvider         →  SignInUseCase
//   signOutUseCaseProvider        →  SignOutUseCase
//   resetPasswordUseCaseProvider  →  ResetPasswordUseCase
//   authStateProvider             →  StreamProvider<UserEntity?> (route guard)
//   authNotifierProvider          →  AsyncNotifier (form state: loading/error)
//
// Referensi:
//   Architecture.md §6 — State Management Pattern: Provider, AsyncNotifier
//   Architecture.md §7 — Routing: route guard bergantung pada authStateProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../../../core/errors/failures.dart';

// ── Dependency Providers ─────────────────────────────────────────────────────

/// Menyediakan instance [AuthRemoteDataSourceImpl].
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

/// Menyediakan instance [AuthRepositoryImpl] dengan datasource yang sudah diinject.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

/// Menyediakan [SignUpUseCase].
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

/// Menyediakan [SignInUseCase].
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

/// Menyediakan [SignOutUseCase].
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

/// Menyediakan [ResetPasswordUseCase].
final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

// ── State Providers ──────────────────────────────────────────────────────────

/// Stream status autentikasi — digunakan oleh route guard di app_router.dart.
///
/// Mengembalikan [UserEntity] jika ada sesi aktif, atau `null` jika belum login.
/// Menggunakan StreamProvider agar router otomatis bereaksi saat login/logout.
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ── Auth Notifier ────────────────────────────────────────────────────────────

/// State untuk form-level auth actions (sign in, sign up, dll).
///
/// Menyimpan state loading dan error message untuk ditampilkan di UI.
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  bool get hasError => errorMessage != null;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier yang mengelola state loading/error untuk form auth.
///
/// UI memanggil method di notifier ini, bukan memanggil use case langsung.
/// Setelah operasi selesai, route guard di [authStateProvider] yang
/// menangani navigasi secara otomatis.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  /// Sign in dengan email dan password.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(signInUseCaseProvider)(
      email: email,
      password: password,
    );

    switch (result) {
      case Ok():
        state = const AuthState(isSuccess: true);
      case Err(:final failure):
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Sign up dengan email dan password.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(signUpUseCaseProvider)(
      email: email,
      password: password,
    );

    switch (result) {
      case Ok():
        state = const AuthState(isSuccess: true);
      case Err(:final failure):
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Sign out dari sesi aktif.
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref.read(signOutUseCaseProvider)();

    switch (result) {
      case Ok():
        state = const AuthState();
      case Err(:final failure):
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Update password untuk user yang sedang login.
  Future<void> updatePassword({required String newPassword}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await ref
        .read(resetPasswordUseCaseProvider)(newPassword: newPassword);

    switch (result) {
      case Ok():
        state = const AuthState(isSuccess: true);
      case Err(:final failure):
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
    }
  }

  /// Reset state ke kondisi awal (hapus error, reset loading).
  void reset() => state = const AuthState();
}

/// Provider untuk [AuthNotifier].
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
