import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateThemePreferenceUseCase {
  final ProfileRepository _repository;

  UpdateThemePreferenceUseCase(this._repository);

  Future<Result<void>> call(String userId, String themePreference) async {
    return await _repository.updateThemePreference(userId, themePreference);
  }
}
