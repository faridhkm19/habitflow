import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile(String userId);
  Future<Result<void>> updateDisplayName(String userId, String name);
  Future<Result<String>> uploadAvatar(String userId, String filePath);
  Future<Result<void>> updateThemePreference(String userId, String themePreference);
}
