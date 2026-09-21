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

/// Memvalidasi nama tampilan (display name).
///
/// Wajib diisi, maksimal 50 karakter sesuai skema tabel `profiles`
/// (Architecture.md §4 — profiles.display_name: varchar).
String? validateDisplayName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Nama tidak boleh kosong';
  }
  if (value.trim().length > 50) {
    return 'Nama maksimal 50 karakter';
  }
  return null;
}

// ── Habit Validators (akan diperluas di task 3.2) ────────────────────────────

/// Memvalidasi nama habit.
///
/// Wajib diisi, maksimal 50 karakter sesuai skema tabel `habits`
/// (Architecture.md §4 — habits.name: varchar, max 50).
String? validateHabitName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Nama habit tidak boleh kosong';
  }
  if (value.trim().length > 50) {
    return 'Nama habit maksimal 50 karakter';
  }
  return null;
}

/// Memvalidasi catatan check-in (opsional).
///
/// Boleh kosong, namun jika diisi maksimal 100 karakter
/// (Architecture.md §4 — habit_logs.note: varchar 100, PRD §6 FR-3).
String? validateNote(String? value) {
  if (value != null && value.length > 100) {
    return 'Catatan maksimal 100 karakter';
  }
  return null; // catatan bersifat opsional
}

