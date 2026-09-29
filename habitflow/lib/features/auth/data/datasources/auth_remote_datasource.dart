// lib/features/auth/data/datasources/auth_remote_datasource.dart
//
// Data source yang memanggil Supabase Auth secara langsung.
//
// Bertanggung jawab pada satu hal: komunikasi dengan Supabase Auth SDK.
// Tidak ada business logic di sini — hanya call API dan throw exception
// jika terjadi error. Error handling (exception → Failure) dilakukan
// di repository implementation.
//
// Referensi:
//   Architecture.md §2 — Data Layer: data sources memanggil Supabase client
//   Architecture.md §1 — Supabase sebagai backend (auth, database, storage)
//   PRD.md §1 — Supabase Auth: email/password only, no Google Sign-In

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import '../../../../core/config/supabase_config.dart';

/// Abstract interface untuk Supabase Auth data source.
///
/// Dipisahkan sebagai interface agar lebih mudah di-mock saat testing.
abstract class AuthRemoteDataSource {
  Future<UserEntity> signUp({required String email, required String password});
  Future<UserEntity> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> updatePassword({required String newPassword});
  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  });
  UserEntity? getCurrentUser();
  Stream<UserEntity?> get authStateChanges;
}

/// Implementasi [AuthRemoteDataSource] menggunakan Supabase Flutter SDK.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Menggunakan convenience getter dari supabase_config.dart
  // agar tidak perlu inject client secara manual.
  SupabaseClient get _client => supabase;

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('Pendaftaran gagal. Silakan coba lagi.');
    }

    return UserModel.fromSupabaseUser(user).toEntity();
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException(
        'Login gagal. Periksa email dan password kamu.',
      );
    }

    return UserModel.fromSupabaseUser(user).toEntity();
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  @override
  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null || user.email == null) {
      throw const AuthException('Sesi tidak valid.');
    }

    // Re-authenticate untuk keamanan
    await _client.auth.signInWithPassword(
      email: user.email!,
      password: currentPassword,
    );

    // Update email
    await _client.auth.updateUser(UserAttributes(email: newEmail));

    // Paksa refresh session agar state lokal Supabase langsung mendapatkan data user (email) yang baru
    await _client.auth.refreshSession();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user).toEntity();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user).toEntity();
    });
  }
}
