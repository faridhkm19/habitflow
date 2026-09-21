import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<Result<List<HabitEntity>>> call() async {
    return repository.getHabits();
  }
}
