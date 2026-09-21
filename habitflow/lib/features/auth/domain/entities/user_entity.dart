// lib/features/auth/domain/entities/user_entity.dart
//
// Domain entity untuk pengguna yang sudah terautentikasi.
//
// Entity ini sepenuhnya bebas dari dependensi framework maupun database —
// hanya berisi data murni yang relevan untuk domain HabitFlow.
// Konversi dari/ke model Supabase dilakukan di data layer.
//
// Referensi:
//   Architecture.md §2 — Domain Layer: entities bebas dari Supabase
//   Architecture.md §4 — Database Design: auth.users.id, auth.users.email

import 'package:equatable/equatable.dart';

/// Representasi murni pengguna yang terautentikasi di domain layer.
///
/// Hanya berisi field dari `auth.users` yang relevan untuk logika aplikasi.
/// Field tambahan seperti `displayName` dan `avatarUrl` disimpan di tabel
/// `profiles` dan dikelola oleh fitur profile (task 5.3).
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  /// UUID dari Supabase Auth (`auth.users.id`).
  final String id;

  /// Email pengguna.
  /// Bersifat simulasi — tidak wajib email asli (PRD §6 FR-1).
  final String email;

  /// Waktu akun dibuat di Supabase Auth.
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, email, createdAt];

  @override
  String toString() => 'UserEntity(id: $id, email: $email)';
}
