import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../../logging/presentation/providers/home_provider.dart';
import '../../domain/usecases/calculate_consistency_score_usecase.dart';
import '../../domain/usecases/calculate_streak_usecase.dart';

final calculateStreakUseCaseProvider = Provider<CalculateStreakUseCase>((ref) {
  final logRepo = ref.watch(habitLogRepositoryProvider);
  final habitRepo = ref.watch(habitRepositoryProvider);
  return CalculateStreakUseCase(
    logRepository: logRepo,
    habitRepository: habitRepo,
  );
});

final calculateConsistencyScoreUseCaseProvider =
    Provider<CalculateConsistencyScoreUseCase>((ref) {
      final logRepo = ref.watch(habitLogRepositoryProvider);
      return CalculateConsistencyScoreUseCase(logRepository: logRepo);
    });

final currentStreakProvider = FutureProvider.family<int, String>((
  ref,
  habitId,
) async {
  // Re-evaluate when logs are added/removed (watch homeProvider)
  ref.watch(homeProvider);

  final habits = await ref.watch(habitsProvider.future);
  final habit = habits.firstWhere((h) => h.id == habitId);

  final useCase = ref.watch(calculateStreakUseCaseProvider);
  final result = await useCase(habit);

  return result.valueOrNull ?? 0;
});

final consistencyScoreProvider = FutureProvider.family<double, String>((
  ref,
  habitId,
) async {
  // Re-evaluate when logs are added/removed (watch homeProvider)
  ref.watch(homeProvider);

  final habits = await ref.watch(habitsProvider.future);
  final habit = habits.firstWhere((h) => h.id == habitId);

  final useCase = ref.watch(calculateConsistencyScoreUseCaseProvider);
  final result = await useCase(habit);

  return result.valueOrNull ?? 0.0;
});
