import '../../../../core/errors/failures.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await _remoteDataSource.fetchProfile(userId);
      return Ok(profile);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateDisplayName(String userId, String name) async {
    try {
      await _remoteDataSource.updateDisplayName(userId, name);
      return const Ok(null);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> uploadAvatar(String userId, String filePath) async {
    try {
      final url = await _remoteDataSource.uploadAvatar(userId, filePath);
      return Ok(url);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateThemePreference(
    String userId,
    String themePreference,
  ) async {
    try {
      await _remoteDataSource.updateThemePreference(userId, themePreference);
      return const Ok(null);
    } catch (e) {
      return Err(ServerFailure(e.toString()));
    }
  }
}
