import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService instance = PreferencesService._init();
  PreferencesService._init();

  late SharedPreferences _prefs;

  static const String _keyNotificationsEnabled = 'notifications_enabled';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get notificationsEnabled => _prefs.getBool(_keyNotificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_keyNotificationsEnabled, value);
  }
}
