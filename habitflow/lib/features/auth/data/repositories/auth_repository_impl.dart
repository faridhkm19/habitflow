// lib/features/auth/data/repositories/auth_repository_impl.dart
//
// Implementasi konkret dari AuthRepository (domain interface).
//
// Bertanggung jawab:
//   1. Mendelegasikan operasi ke AuthRemoteDataSource
//   2. Menangkap exception dari datasource dan mengkonversinya ke Failure
//   3. Membungkus hasil sukses dalam Result<T>
//
// Pattern ini memastikan domain dan presentation layer tidak pernah
// melihat exception raw dari Supabase — mereka hanya berinteraksi
// dengan Result<T> yang bersih.
//
// Referensi:
//   Architecture.md §2 — Data Layer: repository implementation
//   Architecture.md §6 — State Management: error handling lewat Failure

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/errors/failures.dart';

/// Implementasi [AuthRepository] yang menggunakan [AuthRemoteDataSource].
///
/// Semua exception dari Supabase ditangkap di sini dan dikonversi ke
/// [Failure] yang sesuai, lalu dibungkus dalam [Err].
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<Result<UserEntity>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signUp(email: email, password: password);
      return Ok(user);
    } on AuthException catch (e) {
      return Err(AuthFailure(_mapAuthExceptionMessage(e.message)));
    } on SocketException {
      return const Err(NetworkFailure());
    } catch (e) {
      return Err(ServerFailure('Terjadi kesalahan tidak terduga: ${e.toString()}'));
    }
  }

  @override
  Future<Result<UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);
      return Ok(user);
    } on AuthException catch (e) {
      return Err(AuthFailure(_mapAuthExceptionMessage(e.message)));
    } on SocketException {
      return const Err(NetworkFailure());
    } catch (e) {
      return Err(ServerFailure('Terjadi kesalahan tidak terduga: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Ok(null);
    } on AuthException catch (e) {
      return Err(AuthFailure(_mapAuthExceptionMessage(e.message)));
    } on SocketException {
      return const Err(NetworkFailure());
    } catch (e) {
      return Err(ServerFailure('Gagal logout: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> updatePassword({required String newPassword}) async {
    try {
      await _dataSource.updatePassword(newPassword: newPassword);
      return const Ok(null);
    } on AuthException catch (e) {
      return Err(AuthFailure(_mapAuthExceptionMessage(e.message)));
    } on SocketException {
      return const Err(NetworkFailure());
    } catch (e) {
      return Err(ServerFailure('Gagal mengubah password: ${e.toString()}'));
    }
  }

  @override
  UserEntity? getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Mengkonversi pesan error Supabase (Bahasa Inggris) ke pesan ramah
  /// yang bisa ditampilkan ke pengguna Indonesia.
  String _mapAuthExceptionMessage(String? message) {
    if (message == null) return 'Terjadi kesalahan autentikasi.';

    final lower = message.toLowerCase();

    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid email or password')) {
      return 'Email atau password salah. Periksa kembali dan coba lagi.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('email already')) {
      return 'Email ini sudah terdaftar. Coba login atau gunakan email lain.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Akun belum aktif. Hubungi administrator.';
    }
    if (lower.contains('password should be at least')) {
      return 'Password minimal 6 karakter.';
    }
    if (lower.contains('rate limit') || lower.contains('too many requests')) {
      return 'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';
    }
    if (lower.contains('session') && lower.contains('expired')) {
      return 'Sesi kamu sudah berakhir. Silakan login kembali.';
    }
    if (lower.contains('not authenticated') || lower.contains('no session')) {
      return 'Kamu perlu login untuk melakukan aksi ini.';
    }

    // Fallback: tampilkan pesan asli jika tidak ada mapping
    return message;
  }
}
