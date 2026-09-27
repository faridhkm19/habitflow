import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource untuk mengakses data profile dari Supabase.
/// Scope saat ini: membaca dan mengupdate kolom is_onboarded.
abstract interface class ProfileRemoteDataSource {
  /// Mengambil status apakah user sudah menyelesaikan onboarding.
  Future<bool> fetchIsOnboarded(String userId);

  /// Menandai user sebagai sudah menyelesaikan onboarding.
  Future<void> markAsOnboarded(String userId);
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
}
