import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _notificationsEnabled = true;
  bool _bluetoothEnabled = true;
  bool _motionAlerts = true;
  bool _soundEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get bluetoothEnabled => _bluetoothEnabled;
  bool get motionAlerts => _motionAlerts;
  bool get soundEnabled => _soundEnabled;
  bool get isDark => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setBluetooth(bool value) {
    _bluetoothEnabled = value;
    notifyListeners();
  }

  void setMotionAlerts(bool value) {
    _motionAlerts = value;
    notifyListeners();
  }

  void setSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }
}
