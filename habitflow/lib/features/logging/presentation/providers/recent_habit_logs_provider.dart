import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_log_entity.dart';
import 'home_provider.dart';

final recentHabitLogsProvider =
    FutureProvider.family<List<HabitLogEntity>, String>((ref, habitId) async {
      // Watch homeProvider agar saat ada log baru di-check-in, data ini ikut ter-refresh
      ref.watch(homeProvider);

      final logRepo = ref.watch(habitLogRepositoryProvider);

      // Ambil data log 30 hari terakhir
      final today = DateTime.now();
      final fromDate = today.subtract(const Duration(days: 30));

      final result = await logRepo.getLogsForHabit(habitId, fromDate, today);

      if (result.isOk) {
        final logs = result.valueOrNull ?? [];
        // Urutkan dari yang terbaru
        logs.sort((a, b) => b.logDate.compareTo(a.logDate));
        return logs;
      }

      return [];
    });
