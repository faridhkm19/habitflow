import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logging/presentation/providers/home_provider.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../domain/usecases/get_statistics_usecase.dart';
import '../../domain/entities/habit_statistics.dart';
import '../../../../core/errors/failures.dart';

final getStatisticsUseCaseProvider = Provider<GetStatisticsUseCase>((ref) {
  final logRepository = ref.watch(habitLogRepositoryProvider);
  return GetStatisticsUseCase(logRepository: logRepository);
});

final selectedStatisticsCategoryProvider = StateProvider<String>((ref) => 'all');

final selectedStatisticsHabitIdProvider = StateProvider<String?>((ref) {
  // Try to default to the first habit available
  final habitsAsync = ref.watch(habitsProvider);
  return habitsAsync.valueOrNull?.firstOrNull?.id;
});

final statisticsDataProvider = FutureProvider<HabitStatistics?>((ref) async {
  final habitId = ref.watch(selectedStatisticsHabitIdProvider);
  if (habitId == null) return null;

  final habitsAsync = ref.watch(habitsProvider);
  final habits = habitsAsync.valueOrNull;
  if (habits == null) return null;

  final habit = habits.firstWhere((h) => h.id == habitId);
  final usecase = ref.watch(getStatisticsUseCaseProvider);

  final result = await usecase(habit);
  if (result.isErr) {
    throw Exception(result.failureOrNull!.message);
  }

  return result.valueOrNull;
});
