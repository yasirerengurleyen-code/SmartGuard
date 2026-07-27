import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

class SmartGuardLogo extends StatefulWidget {
  const SmartGuardLogo({
    super.key,
    this.size = 88,
    this.showGlow = true,
    this.animate = true,
  });

  final double size;
  final bool showGlow;
  final bool animate;

  @override
  State<SmartGuardLogo> createState() => _SmartGuardLogoState();
}

class _SmartGuardLogoState extends State<SmartGuardLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    if (widget.animate && widget.showGlow) {
      _breath.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _breath,
        builder: (context, child) {
          final t = widget.animate ? _breath.value : 0.5;
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.showGlow)
                Container(
                  width: widget.size * (0.88 + t * 0.08),
                  height: widget.size * (0.88 + t * 0.08),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent
                            .withValues(alpha: 0.28 + t * 0.18),
                        blurRadius: widget.size * (0.28 + t * 0.12),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              child!,
            ],
          );
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.accentGlow,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            CupertinoIcons.shield_fill,
            size: widget.size * 0.46,
            color: AppColors.voidBlack,
          ),
        ),
      ),
    );
  }
}

/// Optional one-shot entrance for list items (stagger-friendly, 60 FPS).
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.06),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.normal,
      curve: AppMotion.emphasized,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
