import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/alarm_mode.dart';
import '../../models/history_event.dart';
import '../../providers/history_provider.dart';
import '../../providers/system_status_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../utils/constants.dart';
import '../../utils/date_formatters.dart';
import '../../utils/responsive.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/page_background.dart';
import '../../widgets/premium_icon.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/status_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SystemStatusProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageBackground(
      child: SafeArea(
        bottom: false,
        child: ResponsiveLayout(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.pagePadding,
            8,
            AppConstants.pagePadding,
            110,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _HeroHeader(armed: status.alarmArmed, isDark: isDark),
                    const SizedBox(height: 22),
                    _StatusCards(status: status),
                    const SizedBox(height: 20),
                    _ArmControls(status: status),
                    const SizedBox(height: 26),
                    const SectionHeader(
                      title: 'Mod',
                      subtitle: 'Koruma davranışını seçin',
                    ),
                    const SizedBox(height: 12),
                    _ModeSelector(status: status),
                    const SizedBox(height: 26),
                    const SectionHeader(title: 'Son Alarm'),
                    const SizedBox(height: 12),
                    _LastAlarmCard(status: status),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.armed, required this.isDark});

  final bool armed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      borderColor: armed
          ? AppColors.accent.withValues(alpha: 0.35)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Akıllı güvenlik paneli',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: AppMotion.normal,
                curve: AppMotion.standard,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: armed ? AppColors.accentGlow : null,
                  color: armed
                      ? null
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04)),
                  boxShadow: armed
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  armed ? AppIcons.shield : AppIcons.shieldOutline,
                  color: armed
                      ? AppColors.voidBlack
                      : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          StatusBadge(
            label: armed ? 'Koruma Aktif' : 'Koruma Beklemede',
            active: armed,
            activeColor: AppColors.success,
            inactiveColor: AppColors.textTertiaryDark,
            pulse: armed,
          ),
        ],
      ),
    );
  }
}

class _StatusCards extends StatelessWidget {
  const _StatusCards({required this.status});

  final SystemStatusProvider status;

  @override
  Widget build(BuildContext context) {
    final bluetoothCard = LiveBluetoothCard(
      isOn: status.bluetoothOn,
      onTap: () {
        HapticFeedback.selectionClick();
        status.toggleBluetooth();
      },
    );

    final espCard = AnimatedEsp32Card(
      connected: status.esp32Connected,
      enabled: status.bluetoothOn,
      onTap: status.bluetoothOn
          ? () {
              HapticFeedback.selectionClick();
              status.toggleEsp32();
            }
          : null,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 420) {
          return Row(
            children: [
              Expanded(child: bluetoothCard),
              const SizedBox(width: 12),
              Expanded(child: espCard),
            ],
          );
        }
        return Column(
          children: [
            bluetoothCard,
            const SizedBox(height: 12),
            espCard,
          ],
        );
      },
    );
  }
}

class _ArmControls extends StatelessWidget {
  const _ArmControls({required this.status});

  final SystemStatusProvider status;

  void _arm(BuildContext context) {
    HapticFeedback.mediumImpact();
    status.armAlarm();
    context.read<HistoryProvider>().addEvent(
          HistoryEvent(
            id: const Uuid().v4(),
            type: HistoryEventType.systemArmed,
            title: 'Sistem Kuruldu',
            subtitle: status.mode.label,
            timestamp: DateTime.now(),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm kuruldu')),
    );
  }

  void _disarm(BuildContext context) {
    HapticFeedback.mediumImpact();
    status.disarmAlarm();
    context.read<HistoryProvider>().addEvent(
          HistoryEvent(
            id: const Uuid().v4(),
            type: HistoryEventType.systemDisarmed,
            title: 'Sistem Kapatıldı',
            subtitle: 'Manuel',
            timestamp: DateTime.now(),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm kapatıldı')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientButton(
          label: 'Alarmı Kur',
          icon: AppIcons.shield,
          enablePressScale: true,
          onPressed: status.alarmArmed ? null : () => _arm(context),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: 'Alarmı Kapat',
          icon: AppIcons.shieldOutline,
          gradient: AppColors.dangerGlow,
          foregroundColor: Colors.white,
          enablePressScale: true,
          onPressed: status.alarmArmed ? () => _disarm(context) : null,
        ),
      ],
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({required this.status});

  final SystemStatusProvider status;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return GlassCard(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: AlarmMode.values.map((mode) {
          final selected = status.mode == mode;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.standard,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: selected ? AppColors.accentGlow : null,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.28),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashFactory: InkSparkle.splashFactory,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      status.setMode(mode);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Column(
                        children: [
                          AnimatedScale(
                            scale: selected ? 1.08 : 1,
                            duration: AppMotion.fast,
                            curve: AppMotion.standard,
                            child: Icon(
                              mode.icon,
                              size: 22,
                              color: selected ? AppColors.voidBlack : muted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            mode.label,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color:
                                      selected ? AppColors.voidBlack : muted,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LastAlarmCard extends StatelessWidget {
  const _LastAlarmCard({required this.status});

  final SystemStatusProvider status;

  @override
  Widget build(BuildContext context) {
    final hasData = status.lastAlarmAt != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      child: Row(
        children: [
          PremiumIcon(
            icon: hasData ? AppIcons.bell : AppIcons.schedule,
            size: 48,
            radius: 15,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasData
                      ? (status.lastAlarmLabel ?? 'Alarm')
                      : 'Henüz kayıt yok',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasData
                      ? DateFormatters.relative(status.lastAlarmAt!)
                      : 'Alarm kurduğunuzda burada görünecek',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 16,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiaryLight,
          ),
        ],
      ),
    );
  }
}
