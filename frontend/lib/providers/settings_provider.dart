import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  final _box = Hive.box('settings_box');

  bool get notificationsEnabled => _box.get('notifications_enabled', defaultValue: true);
  TimeOfDay get reminderTime {
    final hour = _box.get('reminder_hour', defaultValue: 20);
    final minute = _box.get('reminder_minute', defaultValue: 0);
    return TimeOfDay(hour: hour, minute: minute);
  }
  bool get darkMode => _box.get('dark_mode', defaultValue: false);

  void toggleNotifications(bool value) {
    _box.put('notifications_enabled', value);
    if (value) {
      updateReminder(reminderTime);
    } else {
      NotificationService.cancelAll();
    }
    notifyListeners();
  }

  void updateReminder(TimeOfDay time) {
    _box.put('reminder_hour', time.hour);
    _box.put('reminder_minute', time.minute);
    if (notificationsEnabled) {
      NotificationService.scheduleDailyReminder(time.hour, time.minute);
    }
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _box.put('dark_mode', value);
    notifyListeners();
  }
}
