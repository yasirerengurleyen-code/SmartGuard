import 'package:flutter/material.dart';

import '../models/alarm_item.dart';

class AlarmsProvider extends ChangeNotifier {
  AlarmsProvider() {
    _alarms = [
      AlarmItem(
        title: 'Sabah Güvenlik',
        time: const TimeOfDay(hour: 7, minute: 0),
        days: const [1, 2, 3, 4, 5],
        note: 'Evden çıkış kontrolü',
      ),
      AlarmItem(
        title: 'Gece Modu',
        time: const TimeOfDay(hour: 23, minute: 0),
        days: const [1, 2, 3, 4, 5, 6, 7],
        note: 'Tam koruma',
      ),
      AlarmItem(
        title: 'Hafta Sonu',
        time: const TimeOfDay(hour: 9, minute: 30),
        enabled: false,
        days: const [6, 7],
      ),
    ];
  }

  late List<AlarmItem> _alarms;

  List<AlarmItem> get alarms => List.unmodifiable(_alarms);

  List<AlarmItem> get activeAlarms =>
      _alarms.where((a) => a.enabled).toList(growable: false);

  void addAlarm(AlarmItem alarm) {
    _alarms = [..._alarms, alarm];
    notifyListeners();
  }

  void updateAlarm(AlarmItem alarm) {
    final index = _alarms.indexWhere((a) => a.id == alarm.id);
    if (index < 0) return;
    final next = [..._alarms];
    next[index] = alarm;
    _alarms = next;
    notifyListeners();
  }

  void deleteAlarm(String id) {
    _alarms = _alarms.where((a) => a.id != id).toList();
    notifyListeners();
  }

  void toggleAlarm(String id) {
    final index = _alarms.indexWhere((a) => a.id == id);
    if (index < 0) return;
    final current = _alarms[index];
    final next = [..._alarms];
    next[index] = current.copyWith(enabled: !current.enabled);
    _alarms = next;
    notifyListeners();
  }
}
