import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentDateNotifier extends StateNotifier<DateTime> with WidgetsBindingObserver {
  Timer? _timer;

  CurrentDateNotifier() : super(DateTime.now()) {
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _checkDate());
  }

  void _checkDate() {
    final now = DateTime.now();
    if (now.day != state.day || now.month != state.month || now.year != state.year) {
      state = now;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDate();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}

final currentDateProvider = StateNotifierProvider<CurrentDateNotifier, DateTime>((ref) {
  return CurrentDateNotifier();
});
