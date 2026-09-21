import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit_model.dart';

abstract class HabitRemoteDataSource {
  Future<List<HabitModel>> getHabits();
  Future<List<HabitModel>> createBatchHabits(List<HabitModel> habits);
  Future<void> updateLongestStreak(String id, int newStreak);
  // Method lain (create, update, delete) akan ditambahkan di Task 3.2
}

class HabitRemoteDataSourceImpl implements HabitRemoteDataSource {
  final SupabaseClient supabaseClient;

  HabitRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<HabitModel>> getHabits() async {
    // Karena ada RLS, tidak perlu where user_id secara eksplisit, 
    // tapi lebih aman ditulis juga agar jelas secara logika
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');

    final response = await supabaseClient
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: true);

    return (response as List).map((e) => HabitModel.fromJson(e)).toList();
  }

  @override
  Future<List<HabitModel>> createBatchHabits(List<HabitModel> habits) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');

    final dataToInsert = habits.map((h) => h.toJson()).toList();

    // insert multiple rows
    final response = await supabaseClient
        .from('habits')
        .insert(dataToInsert)
        .select();

    return (response as List).map((e) => HabitModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateLongestStreak(String id, int newStreak) async {
    await supabaseClient
        .from('habits')
        .update({'longest_streak': newStreak})
        .eq('id', id);
  }
}
