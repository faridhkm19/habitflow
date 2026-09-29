import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitflow/core/errors/failures.dart';

import '../../../habits/domain/entities/habit_entity.dart';
import '../../../logging/domain/entities/habit_log_entity.dart';

import '../../../logging/presentation/providers/home_provider.dart';

class CalendarViewState {
  final DateTime currentMonth;
  final List<HabitLogEntity> logs;
  final bool isLoading;

  CalendarViewState({
    required this.currentMonth,
    this.logs = const [],
    this.isLoading = false,
  });

  CalendarViewState copyWith({
    DateTime? currentMonth,
    List<HabitLogEntity>? logs,
    bool? isLoading,
  }) {
    return CalendarViewState(
      currentMonth: currentMonth ?? this.currentMonth,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CalendarViewNotifier extends AutoDisposeFamilyNotifier<CalendarViewState, HabitEntity> {
  @override
  CalendarViewState build(HabitEntity arg) {
    // Watch homeProvider so if there's a check-in outside, this screen refreshes
    ref.watch(homeProvider);
    
    // Initial month is current month
    final now = DateTime.now();
    final initialState = CalendarViewState(
      currentMonth: DateTime(now.year, now.month, 1),
      isLoading: true,
    );
    
    // Fetch logs async
    Future.microtask(() => _fetchLogs(initialState.currentMonth));
    
    return initialState;
  }
  
  Future<void> _fetchLogs(DateTime month) async {
    state = state.copyWith(isLoading: true);
    
    final logRepo = ref.read(habitLogRepositoryProvider);
    
    // Get start and end of month
    final fromDate = DateTime(month.year, month.month, 1);
    final toDate = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final result = await logRepo.getLogsForHabit(arg.id, fromDate, toDate);
    
    if (result.isOk) {
      state = state.copyWith(
        logs: result.valueOrNull ?? [],
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
  
  void nextMonth() {
    final next = DateTime(state.currentMonth.year, state.currentMonth.month + 1, 1);
    state = state.copyWith(currentMonth: next);
    _fetchLogs(next);
  }
  
  void prevMonth() {
    final prev = DateTime(state.currentMonth.year, state.currentMonth.month - 1, 1);
    
    // Batasan: Jangan mundur sebelum bulan habit dibuat
    final createdAtMonth = DateTime(arg.createdAt.year, arg.createdAt.month, 1);
    if (prev.isBefore(createdAtMonth)) return;
    
    state = state.copyWith(currentMonth: prev);
    _fetchLogs(prev);
  }
}

final calendarViewProvider = NotifierProvider.autoDispose.family<CalendarViewNotifier, CalendarViewState, HabitEntity>(
  CalendarViewNotifier.new,
);
