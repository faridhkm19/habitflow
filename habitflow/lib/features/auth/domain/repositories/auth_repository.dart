// lib/features/auth/domain/repositories/auth_repository.dart
//
// Abstract interface untuk autentikasi di domain layer.
//
// Domain layer hanya bergantung pada interface ini, bukan pada implementasinya
// di data layer. Ini memungkinkan testing yang mudah dan pemisahan concerns
// yang bersih sesuai Clean Architecture.
//
// Referensi:
//   Architecture.md §2 — Domain Layer: repository interface (kontrak abstrak)
//   Architecture.md §7 — Routing: route guard bergantung pada authStateChanges

import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

/// Kontrak abstrak untuk seluruh operasi autentikasi.
///
/// Diimplementasikan oleh [AuthRepositoryImpl] di data layer.
/// Menggunakan [Result<T>] sebagai return type untuk error handling
/// yang eksplisit tanpa exception propagation ke presentation layer.
abstract class AuthRepository {
  /// Mendaftarkan user baru dengan email dan password.
  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
  });

  /// Login dengan email dan password yang sudah terdaftar.
  ///
  /// Mengembalikan [UserEntity] jika berhasil, atau [Failure] jika gagal.
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Logout dari sesi aktif saat ini.
  Future<Result<void>> signOut();

  /// Mengubah password pengguna yang sedang aktif (memerlukan sesi valid).
  ///
  /// Alur "Forgot Password" di HabitFlow bersifat simulasi — tidak ada
  /// pengiriman email verifikasi. User yang masih punya sesi aktif dapat
  /// mengubah password-nya lewat form di aplikasi.
  Future<Result<void>> updatePassword({required String newPassword});

  /// Mengubah email pengguna yang sedang aktif dengan memverifikasi password saat ini.
  Future<Result<void>> updateEmail({
    required String newEmail,
    required String currentPassword,
  });

  /// Mengambil user yang sedang login dari sesi lokal Supabase.
  ///
  /// Mengembalikan `null` jika tidak ada sesi aktif (belum login).
  UserEntity? getCurrentUser();

  /// Stream perubahan status autentikasi.
  ///
  /// Digunakan oleh [authStateProvider] (Riverpod) untuk route guard
  /// dan session persistence — merespons login, logout, dan token refresh.
  Stream<UserEntity?> get authStateChanges;
}
