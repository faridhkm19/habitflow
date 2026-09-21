// lib/features/auth/domain/usecases/sign_up_usecase.dart
//
// Use case: mendaftarkan user baru dengan email dan password.
//
// Referensi:
//   Architecture.md §2 — Domain Layer: use case adalah satu class untuk satu aksi
//   PRD.md §6 FR-1 — register dengan email (simulasi) dan password
//   Brainstorming.md §7 M1 — email tidak wajib asli, tanpa Google Sign-In

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Mendaftarkan user baru ke Supabase Auth.
///
/// Memanggil [AuthRepository.signUp] dan meneruskan hasilnya ke caller.
/// Tidak ada business logic tambahan di use case ini — semua validasi
/// format sudah dilakukan di presentation layer (form validators).
class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  /// Jalankan sign up dengan [email] dan [password].
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signUp(email: email, password: password);
  }
}
