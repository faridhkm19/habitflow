import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

/// Datasource untuk mengakses data profile dari Supabase.
abstract interface class ProfileRemoteDataSource {
  /// Mengambil status apakah user sudah menyelesaikan onboarding.
  Future<bool> fetchIsOnboarded(String userId);

  /// Menandai user sebagai sudah menyelesaikan onboarding.
  Future<void> markAsOnboarded(String userId);

  /// Mengambil data profil beserta statistik (total habit, longest streak, total check-in)
  Future<ProfileModel> fetchProfile(String userId);

  /// Mengupdate display name
  Future<void> updateDisplayName(String userId, String name);

  /// Mengupdate URL avatar
  Future<void> updateAvatarUrl(String userId, String url);

  /// Mengupload file avatar ke bucket storage dan mengembalikan public URL
  Future<String> uploadAvatar(String userId, String filePath);

  /// Mengupdate preferensi tema
  Future<void> updateThemePreference(String userId, String themePreference);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<bool> fetchIsOnboarded(String userId) async {
    final response = await _client
        .from('profiles')
        .select('is_onboarded')
        .eq('id', userId)
        .single();

    return (response['is_onboarded'] as bool?) ?? false;
  }

  @override
  Future<void> markAsOnboarded(String userId) async {
    await _client
        .from('profiles')
        .update({'is_onboarded': true})
        .eq('id', userId);
  }

  @override
  Future<ProfileModel> fetchProfile(String userId) async {
    // 1. Ambil data dasar profil
    final profileResponse = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    // 2. Ambil total habit aktif (is_archived = false)
    final habitsResponse = await _client
        .from('habits')
        .select('id, longest_streak')
        .eq('user_id', userId)
        .eq('is_archived', false);

    final int totalHabits = (habitsResponse as List).length;

    // 3. Ambil longest streak (maksimum dari seluruh habit)
    int maxLongestStreak = 0;
    for (final habit in habitsResponse) {
      final streak = (habit['longest_streak'] as num?)?.toInt() ?? 0;
      if (streak > maxLongestStreak) maxLongestStreak = streak;
    }

    // 4. Ambil total check-ins dari habit_logs (hanya yang completed)
    final countResponse = await _client
        .from('habit_logs')
        .select('id')
        .eq('user_id', userId)
        .eq('is_completed', true)
        .count(CountOption.exact);

    final int totalCheckIns = countResponse.count;

    return ProfileModel.fromJson(
      profileResponse,
      totalHabits: totalHabits,
      longestStreak: maxLongestStreak,
      totalCheckIns: totalCheckIns,
    );
  }

  @override
  Future<void> updateDisplayName(String userId, String name) async {
    await _client
        .from('profiles')
        .update({'display_name': name})
        .eq('id', userId);
  }

  @override
  Future<void> updateAvatarUrl(String userId, String url) async {
    await _client.from('profiles').update({'avatar_url': url}).eq('id', userId);
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    final file = File(filePath);
    final ext = filePath.split('.').last;
    final path = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _client.storage
        .from('avatars')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    final publicUrl = _client.storage.from('avatars').getPublicUrl(path);

    // Simpan public URL ke tabel profiles
    await updateAvatarUrl(userId, publicUrl);

    return publicUrl;
  }

  @override
  Future<void> updateThemePreference(
    String userId,
    String themePreference,
  ) async {
    await _client
        .from('profiles')
        .update({'theme_preference': themePreference})
        .eq('id', userId);
  }
}
