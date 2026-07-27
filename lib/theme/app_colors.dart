import 'package:flutter/material.dart';

/// SmartGuard color tokens — deep night security aesthetic with teal accent.
abstract final class AppColors {
  static const Color voidBlack = Color(0xFF05070A);
  static const Color surfaceDark = Color(0xFF0C1017);
  static const Color cardDark = Color(0xFF141B24);
  static const Color elevatedDark = Color(0xFF1A2330);

  static const Color surfaceLight = Color(0xFFF2F4F7);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color elevatedLight = Color(0xFFECEFF3);

  static const Color accent = Color(0xFF2DD4BF);
  static const Color accentDim = Color(0xFF14B8A6);
  static const Color accentDeep = Color(0xFF0F766E);
  static const Color accentMuted = Color(0x332DD4BF);

  static const Color danger = Color(0xFFFF5A5F);
  static const Color warning = Color(0xFFF5A524);
  static const Color success = Color(0xFF34D399);
  static const Color info = Color(0xFF5B9FFF);

  static const Color textPrimaryDark = Color(0xFFF7F9FC);
  static const Color textSecondaryDark = Color(0xFF9AA6B2);
  static const Color textTertiaryDark = Color(0xFF6B7785);

  static const Color textPrimaryLight = Color(0xFF0F141B);
  static const Color textSecondaryLight = Color(0xFF5B6775);
  static const Color textTertiaryLight = Color(0xFF8A96A3);

  static const Color dividerDark = Color(0xFF243041);
  static const Color dividerLight = Color(0xFFE2E8F0);

  static const Color glassHighlight = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x22FFFFFF);
  static const Color glassBorderLight = Color(0x66FFFFFF);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF070B12),
      Color(0xFF0A1420),
      Color(0xFF071416),
      Color(0xFF05080C),
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
  );

  static const LinearGradient accentGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5EEAD4), Color(0xFF2DD4BF), Color(0xFF0D9488)],
    stops: [0.0, 0.45, 1.0],
  );

  static const LinearGradient dangerGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A8E), Color(0xFFFF5A5F), Color(0xFFE11D48)],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient ambientOrb = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x552DD4BF), Color(0x2214B8A6), Color(0x00000000)],
  );
}
