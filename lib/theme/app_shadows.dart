import 'package:flutter/material.dart';

/// Layered, Apple-like soft shadows (drawn outside clipped glass surfaces).
abstract final class AppShadows {
  static List<BoxShadow> glass(bool isDark) => isDark
      ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 14),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF2DD4BF).withValues(alpha: 0.04),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
            spreadRadius: -6,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

  static List<BoxShadow> elevated(bool isDark, {Color? glow}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: -4,
        ),
        if (glow != null)
          BoxShadow(
            color: glow.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
      ];

  static List<BoxShadow> button(Color glow) => [
        BoxShadow(
          color: glow.withValues(alpha: 0.38),
          blurRadius: 22,
          offset: const Offset(0, 10),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}
