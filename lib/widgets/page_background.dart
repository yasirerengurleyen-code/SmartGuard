import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared atmospheric page background with soft ambient orbs (static = 60 FPS).
class PageBackground extends StatelessWidget {
  const PageBackground({
    super.key,
    required this.child,
    this.showOrbs = true,
  });

  final Widget child;
  final bool showOrbs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.heroGradient
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceLight,
                  AppColors.elevatedLight.withValues(alpha: 0.95),
                  AppColors.surfaceLight,
                ],
              ),
      ),
      child: Stack(
        children: [
          if (showOrbs && isDark) ...[
            const Positioned(
              top: -80,
              right: -60,
              child: _AmbientOrb(size: 220, opacity: 0.22),
            ),
            const Positioned(
              top: 220,
              left: -90,
              child: _AmbientOrb(size: 180, opacity: 0.12),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  const _AmbientOrb({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: opacity),
              AppColors.accent.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
