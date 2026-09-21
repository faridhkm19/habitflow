import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class CreateBatchHabitsUseCase {
  final HabitRepository repository;

  CreateBatchHabitsUseCase(this.repository);

  Future<Result<List<HabitEntity>>> call(List<HabitEntity> habits) async {
    if (habits.isEmpty) {
      return const Err(ServerFailure('Daftar habit tidak boleh kosong'));
    }
    return repository.createBatchHabits(habits);
  }
}
