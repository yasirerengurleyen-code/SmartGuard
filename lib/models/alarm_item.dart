import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AlarmItem {
  AlarmItem({
    String? id,
    required this.title,
    required this.time,
    this.enabled = true,
    this.days = const [1, 2, 3, 4, 5],
    this.note,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final TimeOfDay time;
  final bool enabled;
  final List<int> days; // 1=Mon … 7=Sun
  final String? note;

  AlarmItem copyWith({
    String? id,
    String? title,
    TimeOfDay? time,
    bool? enabled,
    List<int>? days,
    String? note,
  }) {
    return AlarmItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      days: days ?? this.days,
      note: note ?? this.note,
    );
  }

  String get formattedTime {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get daysLabel {
    const names = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    if (days.length == 7) return 'Her gün';
    if (days.length == 5 &&
        days.contains(1) &&
        days.contains(2) &&
        days.contains(3) &&
        days.contains(4) &&
        days.contains(5)) {
      return 'Hafta içi';
    }
    if (days.length == 2 && days.contains(6) && days.contains(7)) {
      return 'Hafta sonu';
    }
    return days.map((d) => names[d - 1]).join(', ');
  }
}
