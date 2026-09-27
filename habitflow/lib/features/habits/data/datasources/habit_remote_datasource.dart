import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit_model.dart';

abstract class HabitRemoteDataSource {
  Future<List<HabitModel>> getHabits();
  Future<List<HabitModel>> createBatchHabits(List<HabitModel> habits);
  Future<HabitModel> updateHabit(HabitModel habit);
  Future<void> archiveHabit(String id);
  Future<void> deleteHabit(String id);
  Future<void> updateLongestStreak(String id, int newStreak);
}

class HabitRemoteDataSourceImpl implements HabitRemoteDataSource {
  final SupabaseClient supabaseClient;

  HabitRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<HabitModel>> getHabits() async {
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

    final response = await supabaseClient
        .from('habits')
        .insert(dataToInsert)
        .select();

    return (response as List).map((e) => HabitModel.fromJson(e)).toList();
  }

  @override
  Future<HabitModel> updateHabit(HabitModel habit) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');

    final response = await supabaseClient
        .from('habits')
        .update(habit.toJson())
        .eq('id', habit.id)
        .eq('user_id', userId)
        .select()
        .single();

    return HabitModel.fromJson(response);
  }

  @override
  Future<void> archiveHabit(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');

    await supabaseClient
        .from('habits')
        .update({'is_archived': true})
        .eq('id', id)
        .eq('user_id', userId);
  }

  @override
  Future<void> deleteHabit(String id) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) throw const AuthException('User not logged in');

    await supabaseClient
        .from('habits')
        .delete()
        .eq('id', id)
        .eq('user_id', userId);
  }

  @override
  Future<void> updateLongestStreak(String id, int newStreak) async {
    await supabaseClient
        .from('habits')
        .update({'longest_streak': newStreak})
        .eq('id', id);
  }
}
