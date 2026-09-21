// lib/features/auth/domain/usecases/reset_password_usecase.dart
//
// Use case: mengubah password user yang sedang aktif (session-based).
//
// PENTING — Tentang alur "Forgot Password" di HabitFlow:
//   Karena email bersifat simulasi dan fitur "Confirm email" Supabase
//   dinonaktifkan, tidak ada mekanisme reset password via email sungguhan.
//   Alur yang diimplementasikan:
//     - User yang punya sesi aktif dapat mengubah password dari dalam app
//     - Memanggil Supabase updateUser() yang hanya bekerja dengan session valid
//   Ini sudah cukup untuk keperluan latihan dan melatih form + Supabase SDK.
//
// Referensi:
//   PRD.md §6 FR-1 — "reset password lewat form khusus di dalam aplikasi
//                      (tanpa pengiriman email verifikasi sungguhan)"
//   Architecture.md §2 — Domain Layer: use case

import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Mengubah password user yang saat ini memiliki sesi aktif.
///
/// Memanggil [AuthRepository.updatePassword] dengan password baru.
/// Hanya berfungsi jika ada sesi Supabase yang valid.
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  /// Jalankan update password dengan [newPassword].
  Future<Result<void>> call({required String newPassword}) {
    return _repository.updatePassword(newPassword: newPassword);
  }
}
