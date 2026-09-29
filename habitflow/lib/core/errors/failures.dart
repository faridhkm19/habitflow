// lib/core/errors/failures.dart
//
// Domain-layer failure types and custom Result<T> sealed class.
//
// Tidak menggunakan package `dartz` agar scope pembelajaran tetap sederhana.
// Sebagai gantinya, digunakan custom sealed class Result<T> yang idiomatic
// Dart modern dan tidak membutuhkan dependensi tambahan.
//
// Hierarki Failure:
//   Failure (sealed)
//   ├── AuthFailure    — error spesifik autentikasi (email sudah terdaftar, dll)
//   ├── ServerFailure  — error dari Supabase / response tidak terduga
//   └── NetworkFailure — koneksi putus / timeout

// ── Failure hierarchy ────────────────────────────────────────────────────────

/// Base class untuk semua domain-layer failures.
///
/// Setiap failure membawa [message] yang bisa ditampilkan ke user
/// (setelah diformat ulang di presentation layer jika perlu).
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Error spesifik autentikasi — misalnya email sudah terdaftar,
/// password salah, atau session tidak valid.
final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Error dari server / Supabase — respons tidak terduga atau
/// exception yang tidak diantisipasi.
final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Error koneksi jaringan — device offline atau request timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Tidak ada koneksi internet. Periksa jaringan kamu.',
  ]);
}

// ── Result<T> — custom Either alternative ────────────────────────────────────

/// Representasi hasil operasi yang bisa berhasil ([Ok]) atau gagal ([Err]).
///
/// Menggantikan `Either<Failure, T>` dari `dartz` tanpa membutuhkan
/// dependensi tambahan.
///
/// Contoh penggunaan:
/// ```dart
/// final result = await signInUseCase(email: e, password: p);
/// switch (result) {
///   case Ok(:final value) => navigateTo('/home'),
///   case Err(:final failure) => showSnackBar(failure.message),
/// }
/// ```
sealed class Result<T> {
  const Result();
}

/// Hasil sukses yang membawa nilai [value] bertipe [T].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// Hasil gagal yang membawa [failure] bertipe [Failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}

// ── Convenience extensions ───────────────────────────────────────────────────

extension ResultX<T> on Result<T> {
  /// `true` jika result adalah [Ok].
  bool get isOk => this is Ok<T>;

  /// `true` jika result adalah [Err].
  bool get isErr => this is Err<T>;

  /// Mengambil nilai dari [Ok], atau `null` jika [Err].
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  /// Mengambil [Failure] dari [Err], atau `null` jika [Ok].
  Failure? get failureOrNull => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };
}
