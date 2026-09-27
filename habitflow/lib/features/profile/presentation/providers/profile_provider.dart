import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// --- Datasource ---
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl(Supabase.instance.client);
});

/// Membaca status is_onboarded dari tabel profiles untuk user yang sedang login.
/// Digunakan oleh route guard di app_router.dart sebagai pengganti userHasHabitsProvider.
///
/// Mengembalikan:
///   - true  ? user sudah menyelesaikan onboarding, arahkan ke /home
///   - false ? user baru setelah Sign Up, arahkan ke /onboarding/guided-setup
///   - null  ? user belum login (authState belum ada)
final isOnboardedProvider = FutureProvider<bool?>((ref) async {
  final authAsync = ref.watch(authStateProvider);
  final user = authAsync.valueOrNull;

  // Belum login ? kembalikan null, biarkan route guard auth yang handle
  if (user == null) return null;

  final datasource = ref.read(profileRemoteDataSourceProvider);
  return datasource.fetchIsOnboarded(user.id);
});

/// Menandai user yang sedang login sebagai sudah menyelesaikan onboarding.
/// Dipanggil dari onboarding_provider setelah saveHabits() berhasil.
Future<void> markUserAsOnboarded(Ref ref) async {
  final user = ref.read(authStateProvider).valueOrNull;
  if (user == null) return;

  final datasource = ref.read(profileRemoteDataSourceProvider);
  await datasource.markAsOnboarded(user.id);

  // Refresh provider agar route guard otomatis bereaksi
  ref.invalidate(isOnboardedProvider);
}
