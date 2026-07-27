import 'package:flutter/material.dart';

enum AlarmMode { automatic, on, off }

extension AlarmModeX on AlarmMode {
  String get label {
    switch (this) {
      case AlarmMode.automatic:
        return 'Otomatik';
      case AlarmMode.on:
        return 'Açık';
      case AlarmMode.off:
        return 'Kapalı';
    }
  }

  IconData get icon {
    switch (this) {
      case AlarmMode.automatic:
        return Icons.auto_mode_rounded;
      case AlarmMode.on:
        return Icons.shield_rounded;
      case AlarmMode.off:
        return Icons.shield_outlined;
    }
  }
}
