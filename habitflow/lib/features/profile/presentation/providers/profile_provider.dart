import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_display_name_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/update_theme_preference_usecase.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/errors/failures.dart';

// --- Datasource ---
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl(Supabase.instance.client);
});

// --- Repository ---
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final ds = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(ds);
});

// --- Use Cases ---
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  return GetProfileUseCase(ref.watch(profileRepositoryProvider));
});

final updateDisplayNameUseCaseProvider = Provider<UpdateDisplayNameUseCase>((ref) {
  return UpdateDisplayNameUseCase(ref.watch(profileRepositoryProvider));
});

final uploadAvatarUseCaseProvider = Provider<UploadAvatarUseCase>((ref) {
  return UploadAvatarUseCase(ref.watch(profileRepositoryProvider));
});

final updateThemePreferenceUseCaseProvider = Provider<UpdateThemePreferenceUseCase>((ref) {
  return UpdateThemePreferenceUseCase(ref.watch(profileRepositoryProvider));
});

/// Membaca status is_onboarded dari tabel profiles untuk user yang sedang login.
final isOnboardedProvider = FutureProvider<bool?>((ref) async {
  final authAsync = ref.watch(authStateProvider);
  final user = authAsync.valueOrNull;

  if (user == null) return null;

  final datasource = ref.read(profileRemoteDataSourceProvider);
  return datasource.fetchIsOnboarded(user.id);
});

Future<void> markUserAsOnboarded(Ref ref) async {
  final user = ref.read(authStateProvider).valueOrNull;
  if (user == null) return;

  final datasource = ref.read(profileRemoteDataSourceProvider);
  await datasource.markAsOnboarded(user.id);

  ref.invalidate(isOnboardedProvider);
}

// --- Data Provider ---
final profileDataProvider = FutureProvider<ProfileEntity?>((ref) async {
  final authAsync = ref.watch(authStateProvider);
  final user = authAsync.valueOrNull;
  if (user == null) return null;

  final getProfile = ref.watch(getProfileUseCaseProvider);
  final result = await getProfile(user.id);

  if (result.isOk) {
    return result.valueOrNull;
  }
  return null;
});

// --- Notifiers ---
class EditProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  EditProfileNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> updateDisplayName(String name) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncValue.loading();
    final usecase = ref.read(updateDisplayNameUseCaseProvider);
    final result = await usecase(user.id, name);

    if (result.isOk) {
      state = const AsyncValue.data(null);
      ref.invalidate(profileDataProvider);
    } else {
      state = AsyncValue.error(result.failureOrNull!.message, StackTrace.current);
    }
  }
}

final editProfileNotifierProvider = StateNotifierProvider<EditProfileNotifier, AsyncValue<void>>((ref) {
  return EditProfileNotifier(ref);
});

class AvatarUploadNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  AvatarUploadNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> uploadAvatar(String filePath) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncValue.loading();
    final usecase = ref.read(uploadAvatarUseCaseProvider);
    final result = await usecase(user.id, filePath);

    if (result.isOk) {
      state = const AsyncValue.data(null);
      ref.invalidate(profileDataProvider);
    } else {
      state = AsyncValue.error(result.failureOrNull!.message, StackTrace.current);
    }
  }
}

final avatarUploadNotifierProvider = StateNotifierProvider<AvatarUploadNotifier, AsyncValue<void>>((ref) {
  return AvatarUploadNotifier(ref);
});
