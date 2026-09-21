// lib/features/auth/data/models/user_model.dart
//
// Data model yang memetakan Supabase Auth User ke domain entity.
//
// Model ini berada di data layer dan bertugas menjadi "translator"
// antara struktur data Supabase (supabase_flutter.User) dan domain entity
// (UserEntity) yang bebas dari dependensi eksternal.
//
// Referensi:
//   Architecture.md §2 — Data Layer: models dengan fromJson/toJson
//   Architecture.md §4 — Database Design: auth.users

import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../domain/entities/user_entity.dart';

/// Data model untuk user Supabase Auth.
///
/// Bertanggung jawab untuk memetakan `supabase_flutter.User`
/// ke [UserEntity] domain layer.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  final String id;
  final String email;
  final DateTime createdAt;

  /// Membuat [UserModel] dari Supabase Auth [User].
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  /// Mengkonversi model ini ke [UserEntity] untuk domain layer.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      createdAt: createdAt,
    );
  }
}
