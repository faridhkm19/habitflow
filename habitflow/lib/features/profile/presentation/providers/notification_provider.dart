// lib/features/profile/presentation/providers/notification_provider.dart
//
// PLACEHOLDER — Smart Reminder (4.2) ditunda ke tahap akhir pengembangan.
// Provider ini dikosongkan sementara mengikuti pembersihan NotificationService.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/preferences_service.dart';

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier()
    : super(PreferencesService.instance.notificationsEnabled);

  Future<void> toggle(bool value) async {
    await PreferencesService.instance.setNotificationsEnabled(value);
    state = value;
    // Logika reschedule/cancel akan diimplementasikan kembali di tahap 4.2
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((
  ref,
) {
  return NotificationNotifier();
});
