import '../../../../core/errors/failures.dart';
import '../entities/habit_entity.dart';

abstract class HabitRepository {
  /// Mendapatkan daftar semua habit milik pengguna yang sedang login
  Future<Result<List<HabitEntity>>> getHabits();

  /// Membuat satu habit baru
  Future<Result<HabitEntity>> createHabit(HabitEntity habit);

  /// Membuat beberapa habit sekaligus (untuk onboarding)
  Future<Result<List<HabitEntity>>> createBatchHabits(List<HabitEntity> habits);

  /// Memperbarui data habit (Task 3.2)
  Future<Result<HabitEntity>> updateHabit(HabitEntity habit);

  /// Mengarsipkan habit tanpa menghapusnya (Task 3.2)
  Future<Result<void>> archiveHabit(String id);

  /// Menghapus habit secara permanen (Task 3.2)
  Future<Result<void>> deleteHabit(String id);

  /// Update rekor longest streak (Task 3.4)
  Future<Result<void>> updateLongestStreak(String id, int newStreak);
}
