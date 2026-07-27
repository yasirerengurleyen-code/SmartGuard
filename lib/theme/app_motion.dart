import 'package:flutter/material.dart';

/// Motion tokens tuned for ~60 FPS (transform/opacity only, short durations).
abstract final class AppMotion {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);
  static const Duration splash = Duration(milliseconds: 900);
  static const Duration page = Duration(milliseconds: 340);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuint;
  static const Curve springy = Curves.easeOutBack;
  static const Curve decelerate = Curves.decelerate;

  /// iOS-like push: fade + slight horizontal slide + soft scale.
  static Widget iosTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final curved = CurvedAnimation(parent: animation, curve: emphasized);
    final slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(curved);
    final fade = Tween<double>(begin: 0, end: 1).animate(curved);
    final scale = Tween<double>(begin: 0.985, end: 1).animate(curved);

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(scale: scale, child: child),
      ),
    );
  }

  /// Tab switch: cross-fade with subtle vertical lift (iOS tab feel).
  static Widget tabTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    final curved = CurvedAnimation(parent: animation, curve: standard);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
