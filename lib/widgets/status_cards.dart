import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import 'glass_card.dart';
import 'premium_icon.dart';
import 'status_badge.dart';

/// Live Bluetooth status card with radar pulse when active.
class LiveBluetoothCard extends StatefulWidget {
  const LiveBluetoothCard({
    super.key,
    required this.isOn,
    required this.onTap,
  });

  final bool isOn;
  final VoidCallback onTap;

  @override
  State<LiveBluetoothCard> createState() => _LiveBluetoothCardState();
}

class _LiveBluetoothCardState extends State<LiveBluetoothCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.isOn) _pulse.repeat();
  }

  @override
  void didUpdateWidget(covariant LiveBluetoothCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOn && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!widget.isOn && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: PressableScale(
        onTap: widget.onTap,
        child: GlassCard(
          borderColor: widget.isOn
              ? AppColors.info.withValues(alpha: 0.35)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: AnimatedBuilder(
                      animation: _pulse,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _RadarPainter(
                            progress: widget.isOn ? _pulse.value : 0,
                            color: AppColors.info,
                            active: widget.isOn,
                          ),
                          child: Center(
                            child: PremiumIcon(
                              icon: AppIcons.bluetooth,
                              size: 36,
                              color: widget.isOn
                                  ? AppColors.info
                                  : AppColors.textTertiaryDark,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  StatusBadge(
                    label: widget.isOn ? 'Canlı' : 'Kapalı',
                    active: widget.isOn,
                    activeColor: AppColors.info,
                    inactiveColor: AppColors.textTertiaryDark,
                    pulse: widget.isOn,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Bluetooth',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: AppMotion.fast,
                child: Text(
                  widget.isOn ? 'Sinyal aktif · tarama hazır' : 'Devre dışı',
                  key: ValueKey(widget.isOn),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiaryDark,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.progress,
    required this.color,
    required this.active,
  });

  final double progress;
  final Color color;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    if (!active) return;
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide / 2;

    for (var i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final radius = maxR * (0.45 + t * 0.55);
      final opacity = (1 - t) * 0.35;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = color.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.active != active;
}

/// Animated ESP32 connection card with breathing arc.
class AnimatedEsp32Card extends StatefulWidget {
  const AnimatedEsp32Card({
    super.key,
    required this.connected,
    required this.enabled,
    this.onTap,
  });

  final bool connected;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  State<AnimatedEsp32Card> createState() => _AnimatedEsp32CardState();
}

class _AnimatedEsp32CardState extends State<AnimatedEsp32Card>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.enabled) _spin.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedEsp32Card oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_spin.isAnimating) {
      _spin.repeat();
    } else if (!widget.enabled && _spin.isAnimating) {
      _spin
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        widget.connected ? AppColors.accent : AppColors.warning;

    return RepaintBoundary(
      child: PressableScale(
        onTap: widget.onTap,
        child: GlassCard(
          borderColor: widget.connected
              ? AppColors.accent.withValues(alpha: 0.4)
              : (widget.enabled
                  ? AppColors.warning.withValues(alpha: 0.25)
                  : null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: AnimatedBuilder(
                      animation: _spin,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _OrbitPainter(
                            progress: widget.enabled ? _spin.value : 0,
                            color: accent,
                            connected: widget.connected,
                            enabled: widget.enabled,
                          ),
                          child: child,
                        );
                      },
                      child: Center(
                        child: PremiumIcon(
                          icon: AppIcons.chip,
                          size: 36,
                          color: widget.enabled
                              ? accent
                              : AppColors.textTertiaryDark,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  StatusBadge(
                    label: !widget.enabled
                        ? 'Beklemede'
                        : (widget.connected ? 'Bağlı' : 'Aranıyor'),
                    active: widget.connected,
                    activeColor: AppColors.accent,
                    inactiveColor: widget.enabled
                        ? AppColors.warning
                        : AppColors.textTertiaryDark,
                    pulse: widget.connected,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'ESP32',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: AppMotion.fast,
                child: Text(
                  !widget.enabled
                      ? 'Bluetooth gerekli'
                      : (widget.connected
                          ? 'Cihaz senkron · hazır'
                          : 'Bağlantı bekleniyor'),
                  key: ValueKey('${widget.enabled}_${widget.connected}'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiaryDark,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.progress,
    required this.color,
    required this.connected,
    required this.enabled,
  });

  final double progress;
  final Color color;
  final bool connected;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    if (!enabled) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color.withValues(alpha: 0.15);
    canvas.drawCircle(center, radius, track);

    final sweep = connected ? 1.8 * math.pi : 0.9 * math.pi;
    final start = progress * 2 * math.pi;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: 0.85),
          color,
        ],
        transform: GradientRotation(start),
      ).createShader(rect);

    canvas.drawArc(rect, start, sweep, false, arc);

    if (connected) {
      final glow = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = color.withValues(alpha: 0.12 + 0.08 * math.sin(progress * 2 * math.pi));
      canvas.drawCircle(center, radius * 0.92, glow);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.connected != connected ||
      oldDelegate.enabled != enabled;
}
