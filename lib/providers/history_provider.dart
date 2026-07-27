import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/history_event.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider() {
    final now = DateTime.now();
    _events = [
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.motionDetected,
        title: 'Hareket Algılandı',
        subtitle: 'Ön kapı sensörü',
        timestamp: now.subtract(const Duration(minutes: 12)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.alarmTriggered,
        title: 'Alarm Tetiklendi',
        subtitle: 'Gece Modu',
        timestamp: now.subtract(const Duration(hours: 3)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.systemArmed,
        title: 'Sistem Kuruldu',
        subtitle: 'Otomatik mod',
        timestamp: now.subtract(const Duration(hours: 5)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.motionDetected,
        title: 'Hareket Algılandı',
        subtitle: 'Salon PIR',
        timestamp: now.subtract(const Duration(hours: 8)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.systemDisarmed,
        title: 'Sistem Kapatıldı',
        subtitle: 'Manuel',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.alarmTriggered,
        title: 'Alarm Tetiklendi',
        subtitle: 'Sabah Güvenlik',
        timestamp: now.subtract(const Duration(days: 1, hours: 14)),
      ),
      HistoryEvent(
        id: const Uuid().v4(),
        type: HistoryEventType.motionDetected,
        title: 'Hareket Algılandı',
        subtitle: 'Balkon',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  late List<HistoryEvent> _events;

  List<HistoryEvent> get events => List.unmodifiable(_events);

  List<HistoryEvent> byType(HistoryEventType type) =>
      _events.where((e) => e.type == type).toList(growable: false);

  void addEvent(HistoryEvent event) {
    _events = [event, ..._events];
    notifyListeners();
  }

  void clear() {
    _events = [];
    notifyListeners();
  }
}
