import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_remote_datasource.dart';
import '../models/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource remoteDataSource;

  HabitRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<HabitEntity>>> getHabits() async {
    try {
      final habits = await remoteDataSource.getHabits();
      return Ok(habits);
    } on AuthException {
      return const Err(AuthFailure('Sesi telah berakhir, silakan login kembali.'));
    } on PostgrestException catch (e) {
      return Err(ServerFailure(e.message));
    } on SocketException {
      return const Err(NetworkFailure('Tidak ada koneksi internet.'));
    } catch (e) {
      return const Err(ServerFailure('Terjadi kesalahan yang tidak terduga.'));
    }
  }

  @override
  Future<Result<List<HabitEntity>>> createBatchHabits(List<HabitEntity> habits) async {
    try {
      final models = habits.map((e) => HabitModel.fromEntity(e)).toList();
      final result = await remoteDataSource.createBatchHabits(models);
      return Ok(result);
    } on AuthException {
      return const Err(AuthFailure('Sesi telah berakhir, silakan login kembali.'));
    } on PostgrestException catch (e) {
      return Err(ServerFailure(e.message));
    } on SocketException {
      return const Err(NetworkFailure('Tidak ada koneksi internet.'));
    } catch (e) {
      return const Err(ServerFailure('Terjadi kesalahan saat menyimpan data.'));
    }
  }

  @override
  Future<Result<void>> archiveHabit(String id) {
    throw UnimplementedError(); // Untuk Task 3.2
  }

  @override
  Future<Result<HabitEntity>> createHabit(HabitEntity habit) {
    throw UnimplementedError(); // Untuk Task 3.2
  }

  @override
  Future<Result<void>> deleteHabit(String id) {
    throw UnimplementedError(); // Untuk Task 3.2
  }

  @override
  Future<Result<HabitEntity>> updateHabit(HabitEntity habit) {
    throw UnimplementedError(); // Untuk Task 3.2
  }

  @override
  Future<Result<void>> updateLongestStreak(String id, int newStreak) async {
    try {
      await remoteDataSource.updateLongestStreak(id, newStreak);
      return const Ok(null);
    } on PostgrestException catch (e) {
      return Err(ServerFailure(e.message));
    } on SocketException {
      return const Err(NetworkFailure('Tidak ada koneksi internet.'));
    } catch (e) {
      return const Err(ServerFailure('Terjadi kesalahan saat update streak.'));
    }
  }
}
