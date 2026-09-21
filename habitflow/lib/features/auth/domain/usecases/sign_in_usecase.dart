// lib/features/auth/domain/usecases/sign_in_usecase.dart
//
// Use case: login dengan email dan password yang sudah terdaftar.
//
// Referensi:
//   Architecture.md §2 — Domain Layer: use case
//   PRD.md §6 FR-1 — login dengan email/password, session persistence

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Login user yang sudah terdaftar ke Supabase Auth.
///
/// Memanggil [AuthRepository.signIn] dan meneruskan hasilnya ke caller.
/// Session persistence ditangani otomatis oleh Supabase Flutter SDK
/// setelah login berhasil.
class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Jalankan sign in dengan [email] dan [password].
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
