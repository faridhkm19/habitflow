import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../../logging/presentation/providers/home_provider.dart'; // import to trigger repository
import '../../domain/entities/achievement_entity.dart';
import '../../domain/usecases/get_achievements_usecase.dart';

final getAchievementsUseCaseProvider = Provider<GetAchievementsUseCase>((ref) {
  final logRepository = ref.watch(habitLogRepositoryProvider);
  return GetAchievementsUseCase(logRepository);
});

final achievementsProvider = FutureProvider<List<AchievementEntity>>((ref) async {
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull?.id;
  if (userId == null) return [];

  final habitsAsync = ref.watch(habitsProvider);
  final habits = habitsAsync.valueOrNull;
  if (habits == null) return [];

  final usecase = ref.watch(getAchievementsUseCaseProvider);
  return await usecase(userId, habits);
});
