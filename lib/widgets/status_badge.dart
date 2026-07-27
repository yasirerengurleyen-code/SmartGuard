import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

class StatusBadge extends StatefulWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.active,
    this.activeColor = AppColors.success,
    this.inactiveColor = AppColors.textTertiaryDark,
    this.pulse = false,
  });

  final String label;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final bool pulse;

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.pulse && widget.active) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant StatusBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final should = widget.pulse && widget.active;
    if (should && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!should && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? widget.activeColor : widget.inactiveColor;

    return AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final glow = widget.pulse && widget.active
                  ? 0.35 + _pulse.value * 0.45
                  : (widget.active ? 0.55 : 0.0);
              return Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: widget.active
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: glow),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 7),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
