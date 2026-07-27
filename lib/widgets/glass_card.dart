import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 24,
    this.onTap,
    this.gradient,
    this.borderColor,
    this.blur = 18,
    this.intensity = 1,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? borderColor;
  final double blur;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);

    final card = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: AppShadows.glass(isDark),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur * intensity,
            sigmaY: blur * intensity,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.white.withValues(alpha: 0.11 * intensity),
                            Colors.white.withValues(alpha: 0.04 * intensity),
                            Colors.white.withValues(alpha: 0.02 * intensity),
                          ]
                        : [
                            Colors.white.withValues(alpha: 0.88),
                            Colors.white.withValues(alpha: 0.72),
                          ],
                  ),
              border: Border.all(
                width: 1,
                color: borderColor ??
                    (isDark
                        ? AppColors.glassBorderDark
                        : Colors.white.withValues(alpha: 0.7)),
              ),
            ),
            child: Stack(
              children: [
                // Top specular highlight — Apple glass feel
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 1.2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.22 : 0.55),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(padding: padding, child: child),
              ],
            ),
          ),
        ),
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        splashColor: AppColors.accent.withValues(alpha: 0.14),
        highlightColor: AppColors.accent.withValues(alpha: 0.06),
        splashFactory: InkSparkle.splashFactory,
        child: card,
      ),
    );
  }
}

/// Subtle press scale wrapper for glass / list tiles (60 FPS transform).
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.minScale = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double minScale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.instant,
      reverseDuration: AppMotion.fast,
    );
    _scale = Tween<double>(begin: 1, end: widget.minScale).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _controller.forward(),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              _controller.reverse();
              widget.onTap?.call();
            },
      onTapCancel: widget.onTap == null ? null : _controller.reverse,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
