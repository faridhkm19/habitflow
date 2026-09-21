// lib/features/auth/domain/usecases/sign_out_usecase.dart
//
// Use case: logout dari sesi aktif saat ini.
//
// Referensi:
//   Architecture.md §2 — Domain Layer: use case

import '../repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Logout user dari sesi Supabase Auth saat ini.
///
/// Memanggil [AuthRepository.signOut]. Setelah berhasil, [authStateChanges]
/// akan emit `null` dan route guard akan mengarahkan ke `/login`.
class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// Jalankan sign out.
  Future<Result<void>> call() {
    return _repository.signOut();
  }
}
