// lib/core/utils/validators.dart
//
// Form validation functions untuk auth dan fitur-fitur lainnya.
//
// Semua fungsi mengembalikan String? — null berarti valid, non-null berarti
// pesan error yang ditampilkan langsung di bawah field oleh TextFormField.
//
// Referensi:
//   PRD.md §6 FR-1 — validasi format email dasar, min password length
//   Architecture.md §3 — core/utils/validators.dart
//   Brainstorming.md §7 M1 — email bersifat simulasi, tidak wajib email asli

// ── Auth Validators ───────────────────────────────────────────────────────────

/// Memvalidasi format email secara dasar.
///
/// Email tidak harus asli (sesuai PRD — bersifat simulasi untuk latihan),
/// namun harus memiliki format dasar `x@x.x` agar tidak kosong sembarangan.
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email tidak boleh kosong';
  }
  // Regex dasar: harus ada karakter, @, karakter, titik, karakter
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Format email tidak valid';
  }
  return null;
}

/// Memvalidasi password baru.
///
/// Aturan minimum sesuai default Supabase Auth: minimal 6 karakter.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  return null;
}

/// Memvalidasi password baru saat proses ubah password.
///
/// Aturan: minimal 8 karakter.
String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 8) {
    return 'Password baru minimal 8 karakter';
  }
  return null;
}

/// Memvalidasi konfirmasi password — harus cocok dengan [password].
///
/// Dipanggil dengan nilai field password asli sebagai parameter:
/// ```dart
/// validator: (v) => validateConfirmPassword(passwordController.text, v),
/// ```
String? validateConfirmPassword(String? password, String? confirm) {
  if (confirm == null || confirm.isEmpty) {
    return 'Konfirmasi password tidak boleh kosong';
  }
  if (confirm != password) {
    return 'Password tidak cocok';
  }
  return null;
}
