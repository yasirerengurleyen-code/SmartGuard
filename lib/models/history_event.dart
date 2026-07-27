enum HistoryEventType { alarmTriggered, motionDetected, systemArmed, systemDisarmed }

extension HistoryEventTypeX on HistoryEventType {
  String get label {
    switch (this) {
      case HistoryEventType.alarmTriggered:
        return 'Alarm Tetiklendi';
      case HistoryEventType.motionDetected:
        return 'Hareket Algılandı';
      case HistoryEventType.systemArmed:
        return 'Sistem Kuruldu';
      case HistoryEventType.systemDisarmed:
        return 'Sistem Kapatıldı';
    }
  }

  String get iconName {
    switch (this) {
      case HistoryEventType.alarmTriggered:
        return 'alarm';
      case HistoryEventType.motionDetected:
        return 'motion';
      case HistoryEventType.systemArmed:
        return 'armed';
      case HistoryEventType.systemDisarmed:
        return 'disarmed';
    }
  }
}

class HistoryEvent {
  const HistoryEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.timestamp,
    this.subtitle,
  });

  final String id;
  final HistoryEventType type;
  final String title;
  final DateTime timestamp;
  final String? subtitle;
}
