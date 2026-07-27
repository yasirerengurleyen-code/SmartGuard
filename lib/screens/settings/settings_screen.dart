import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';
import '../../providers/system_status_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../utils/constants.dart';
import '../../utils/responsive.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_background.dart';
import '../../widgets/premium_icon.dart';
import '../../widgets/section_header.dart';
import '../../widgets/smartguard_logo.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final status = context.watch<SystemStatusProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PageBackground(
      child: SafeArea(
        bottom: false,
        child: ResponsiveLayout(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 110),
            children: [
              const SizedBox(height: 12),
              const SectionHeader(
                title: 'Ayarlar',
                subtitle: 'Uygulama tercihleri',
              ),
              const SizedBox(height: 18),
              _SettingsGroup(
                title: 'Tema',
                children: [
                  _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'Koyu Tema',
                    subtitle: isDark
                        ? 'Şu an koyu tema aktif'
                        : 'Açık tema aktif',
                    trailing: Switch.adaptive(
                      value: isDark,
                      onChanged: (value) => settings.setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      ),
                    ),
                  ),
                  _ThemeModeRow(settings: settings),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsGroup(
                title: 'Bildirimler',
                children: [
                  _SettingsTile(
                    icon: AppIcons.bell,
                    title: 'Bildirimler',
                    subtitle: 'Alarm ve sistem uyarıları',
                    trailing: Switch.adaptive(
                      value: settings.notificationsEnabled,
                      onChanged: settings.setNotifications,
                    ),
                  ),
                  _SettingsTile(
                    icon: AppIcons.sensors,
                    title: 'Hareket Uyarıları',
                    subtitle: 'Hareket algılandığında bildir',
                    trailing: Switch.adaptive(
                      value: settings.motionAlerts,
                      onChanged: settings.setMotionAlerts,
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.volume_up_rounded,
                    title: 'Ses',
                    subtitle: 'Alarm sesleri',
                    trailing: Switch.adaptive(
                      value: settings.soundEnabled,
                      onChanged: settings.setSound,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsGroup(
                title: 'Bluetooth',
                children: [
                  _SettingsTile(
                    icon: AppIcons.bluetooth,
                    title: 'Bluetooth',
                    subtitle: settings.bluetoothEnabled
                        ? 'Cihaz taraması etkin'
                        : 'Bluetooth kapalı',
                    trailing: Switch.adaptive(
                      value: settings.bluetoothEnabled,
                      onChanged: (value) {
                        settings.setBluetooth(value);
                        status.setBluetooth(value);
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: AppIcons.chip,
                    title: 'ESP32 Durumu',
                    subtitle: status.esp32Connected
                        ? 'Bağlı (demo)'
                        : 'Bağlı değil (demo)',
                    trailing: Icon(
                      status.esp32Connected
                          ? AppIcons.check
                          : AppIcons.close,
                      color: status.esp32Connected
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    onTap: settings.bluetoothEnabled
                        ? () => status.toggleEsp32()
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SettingsGroup(
                title: 'Hakkında',
                children: [
                  GlassCard(
                    child: Column(
                      children: [
                        const SmartGuardLogo(
                          size: 64,
                          showGlow: true,
                          animate: false,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          AppConstants.appName,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sürüm ${AppConstants.appVersion}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondaryDark,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppConstants.appTagline,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiaryDark,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
          ),
        ),
        ...children.map(
          (child) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          PremiumIcon(icon: icon, size: 42, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _ThemeModeRow extends StatelessWidget {
  const _ThemeModeRow({required this.settings});

  final SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _modeButton(
            context,
            label: 'Sistem',
            selected: settings.themeMode == ThemeMode.system,
            onTap: () => settings.setThemeMode(ThemeMode.system),
          ),
          _modeButton(
            context,
            label: 'Açık',
            selected: settings.themeMode == ThemeMode.light,
            onTap: () => settings.setThemeMode(ThemeMode.light),
          ),
          _modeButton(
            context,
            label: 'Koyu',
            selected: settings.themeMode == ThemeMode.dark,
            onTap: () => settings.setThemeMode(ThemeMode.dark),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: selected ? AppColors.accentGlow : null,
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? AppColors.voidBlack
                            : AppColors.textSecondaryDark,
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
