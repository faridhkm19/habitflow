import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit_log_model.dart';
import '../models/journal_entry_model.dart';

abstract class HabitLogRemoteDataSource {
  Future<void> upsertLog(HabitLogModel log);
  Future<List<HabitLogModel>> getLogsForDate(String userId, DateTime date);
  Future<List<HabitLogModel>> getLogsForHabit(
    String habitId,
    DateTime fromDate,
    DateTime toDate,
  );
  Future<List<HabitLogModel>> getLogsForDateRange(
    String userId,
    DateTime fromDate,
    DateTime toDate,
  );
  Future<List<JournalEntryModel>> getJournalLogs(String userId);
  Future<int> getTotalCompletedCheckIns(String userId);
}

class HabitLogRemoteDataSourceImpl implements HabitLogRemoteDataSource {
  final SupabaseClient supabaseClient;

  HabitLogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> upsertLog(HabitLogModel log) async {
    // Unique constraint di DB: habit_id + log_date
    final json = log.toJson();
    if (json['id'] == null || json['id'].isEmpty) {
      json.remove('id'); // Biar Supabase generate jika baru
    }

    await supabaseClient
        .from('habit_logs')
        .upsert(json, onConflict: 'habit_id,log_date');
  }

  @override
  Future<List<HabitLogModel>> getLogsForDate(
    String userId,
    DateTime date,
  ) async {
    final String dateString = date.toIso8601String().split('T').first;

    final response = await supabaseClient
        .from('habit_logs')
        .select()
        .eq('user_id', userId)
        .eq('log_date', dateString);

    final List<dynamic> data = response;
    return data.map((json) => HabitLogModel.fromJson(json)).toList();
  }

  @override
  Future<List<HabitLogModel>> getLogsForHabit(
    String habitId,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final String fromDateString = fromDate.toIso8601String().split('T').first;
    final String toDateString = toDate.toIso8601String().split('T').first;

    final response = await supabaseClient
        .from('habit_logs')
        .select()
        .eq('habit_id', habitId)
        .gte('log_date', fromDateString)
        .lte('log_date', toDateString)
        .order('log_date', ascending: false);

    final List<dynamic> data = response;
    return data.map((json) => HabitLogModel.fromJson(json)).toList();
  }

  @override
  Future<List<HabitLogModel>> getLogsForDateRange(
    String userId,
    DateTime fromDate,
    DateTime toDate,
  ) async {
    final String fromDateString = fromDate.toIso8601String().split('T').first;
    final String toDateString = toDate.toIso8601String().split('T').first;

    final response = await supabaseClient
        .from('habit_logs')
        .select()
        .eq('user_id', userId)
        .gte('log_date', fromDateString)
        .lte('log_date', toDateString)
        .order('log_date', ascending: false);

    final List<dynamic> data = response;
    return data.map((json) => HabitLogModel.fromJson(json)).toList();
  }

  @override
  Future<List<JournalEntryModel>> getJournalLogs(String userId) async {
    final response = await supabaseClient
        .from('habit_logs')
        .select(
          'habit_id, log_date, is_completed, mood, note, habits!inner(name, icon_name, color_hex)',
        )
        .eq('user_id', userId)
        .or('mood.not.is.null,note.not.is.null')
        .order('log_date', ascending: false)
        .limit(100);

    final List<dynamic> data = response;
    return data.map((json) => JournalEntryModel.fromJson(json)).toList();
  }

  @override
  Future<int> getTotalCompletedCheckIns(String userId) async {
    final count = await supabaseClient
        .from('habit_logs')
        .count(CountOption.exact)
        .eq('user_id', userId)
        .eq('is_completed', true);

    return count;
  }
}
