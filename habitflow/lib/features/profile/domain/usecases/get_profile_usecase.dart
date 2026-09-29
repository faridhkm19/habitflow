import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<Result<ProfileEntity>> call(String userId) async {
    return await _repository.getProfile(userId);
  }
}
