import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient = AppColors.accentGlow,
    this.foregroundColor = AppColors.voidBlack,
    this.height = 58,
    this.enablePressScale = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Gradient gradient;
  final Color foregroundColor;
  final double height;
  final bool enablePressScale;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: AppMotion.instant,
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: AppMotion.standard),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Color get _glowColor {
    final g = widget.gradient;
    if (g is LinearGradient && g.colors.isNotEmpty) {
      return g.colors[g.colors.length > 1 ? 1 : 0];
    }
    return AppColors.accent;
  }

  void _handleTap() {
    final callback = widget.onPressed;
    if (callback == null) return;
    callback();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return AnimatedOpacity(
      duration: AppMotion.fast,
      opacity: enabled ? 1 : 0.42,
      child: ScaleTransition(
        scale: widget.enablePressScale ? _scale : const AlwaysStoppedAnimation(1),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: enabled ? AppShadows.button(_glowColor) : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                gradient: widget.gradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                onTap: enabled ? _handleTap : null,
                onTapDown: enabled && widget.enablePressScale
                    ? (_) => _press.forward()
                    : null,
                onTapUp: enabled && widget.enablePressScale
                    ? (_) => _press.reverse()
                    : null,
                onTapCancel: enabled && widget.enablePressScale
                    ? _press.reverse
                    : null,
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.white.withValues(alpha: 0.28),
                highlightColor: Colors.white.withValues(alpha: 0.1),
                splashFactory: InkRipple.splashFactory,
                child: SizedBox(
                  height: widget.height,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.foregroundColor,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: widget.foregroundColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
