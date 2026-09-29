import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository _repository;

  UploadAvatarUseCase(this._repository);

  Future<Result<String>> call(String userId, String filePath) async {
    return await _repository.uploadAvatar(userId, filePath);
  }
}
