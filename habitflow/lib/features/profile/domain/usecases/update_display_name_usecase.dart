import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateDisplayNameUseCase {
  final ProfileRepository _repository;

  UpdateDisplayNameUseCase(this._repository);

  Future<Result<void>> call(String userId, String name) async {
    return await _repository.updateDisplayName(userId, name);
  }
}
