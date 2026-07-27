import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft, premium icon well used across cards and lists.
class PremiumIcon extends StatelessWidget {
  const PremiumIcon({
    super.key,
    required this.icon,
    this.size = 40,
    this.iconSize,
    this.color = AppColors.accent,
    this.backgroundColor,
    this.radius = 13,
  });

  final IconData icon;
  final double size;
  final double? iconSize;
  final Color color;
  final Color? backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (backgroundColor ?? color).withValues(alpha: 0.22),
            (backgroundColor ?? color).withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: iconSize ?? size * 0.5,
        color: color,
      ),
    );
  }
}

/// Curated Cupertino / Material icon set for consistent premium look.
abstract final class AppIcons {
  static const IconData home = CupertinoIcons.house_fill;
  static const IconData homeOutline = CupertinoIcons.house;
  static const IconData alarm = CupertinoIcons.alarm_fill;
  static const IconData alarmOutline = CupertinoIcons.alarm;
  static const IconData history = CupertinoIcons.clock_fill;
  static const IconData historyOutline = CupertinoIcons.clock;
  static const IconData settings = CupertinoIcons.gear_solid;
  static const IconData settingsOutline = CupertinoIcons.gear;
  static const IconData bluetooth = Icons.bluetooth_rounded;
  static const IconData chip = Icons.memory_rounded;
  static const IconData shield = CupertinoIcons.shield_fill;
  static const IconData shieldOutline = CupertinoIcons.shield;
  static const IconData bell = CupertinoIcons.bell_fill;
  static const IconData schedule = CupertinoIcons.time;
  static const IconData add = CupertinoIcons.add;
  static const IconData delete = CupertinoIcons.trash;
  static const IconData check = CupertinoIcons.check_mark_circled_solid;
  static const IconData close = CupertinoIcons.xmark_circle;
  static const IconData sensors = Icons.sensors_rounded;
  static const IconData modeAuto = Icons.auto_mode_rounded;
}
