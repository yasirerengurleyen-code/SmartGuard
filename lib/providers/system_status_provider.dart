import 'package:flutter/material.dart';

import '../models/alarm_mode.dart';

/// UI-only system status (Bluetooth / ESP32 mock). Gerçek bağlantı sonra eklenecek.
class SystemStatusProvider extends ChangeNotifier {
  bool _bluetoothOn = true;
  bool _esp32Connected = false;
  bool _alarmArmed = false;
  AlarmMode _mode = AlarmMode.automatic;
  DateTime? _lastAlarmAt;
  String? _lastAlarmLabel;

  bool get bluetoothOn => _bluetoothOn;
  bool get esp32Connected => _esp32Connected;
  bool get alarmArmed => _alarmArmed;
  AlarmMode get mode => _mode;
  DateTime? get lastAlarmAt => _lastAlarmAt;
  String? get lastAlarmLabel => _lastAlarmLabel;

  void toggleBluetooth() {
    _bluetoothOn = !_bluetoothOn;
    if (!_bluetoothOn) {
      _esp32Connected = false;
    }
    notifyListeners();
  }

  void setBluetooth(bool value) {
    _bluetoothOn = value;
    if (!value) _esp32Connected = false;
    notifyListeners();
  }

  /// Demo: ESP32 bağlantı durumunu simüle eder.
  void toggleEsp32() {
    if (!_bluetoothOn) return;
    _esp32Connected = !_esp32Connected;
    notifyListeners();
  }

  void setEsp32Connected(bool value) {
    if (!_bluetoothOn && value) return;
    _esp32Connected = value;
    notifyListeners();
  }

  void armAlarm() {
    _alarmArmed = true;
    _lastAlarmAt = DateTime.now();
    _lastAlarmLabel = 'Alarm kuruldu';
    notifyListeners();
  }

  void disarmAlarm() {
    _alarmArmed = false;
    _lastAlarmAt = DateTime.now();
    _lastAlarmLabel = 'Alarm kapatıldı';
    notifyListeners();
  }

  void setMode(AlarmMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
