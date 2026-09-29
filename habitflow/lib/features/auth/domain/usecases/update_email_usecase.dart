import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class UpdateEmailUseCase {
  const UpdateEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({
    required String newEmail,
    required String currentPassword,
  }) async {
    return _repository.updateEmail(
      newEmail: newEmail,
      currentPassword: currentPassword,
    );
  }
}
