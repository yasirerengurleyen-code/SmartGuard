import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_motion.dart';
import '../../widgets/premium_icon.dart';
import '../alarms/alarms_screen.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = <Widget>[
    HomeScreen(),
    AlarmsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  void _onSelect(int value) {
    if (value == _index) return;
    HapticFeedback.selectionClick();
    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: AppMotion.page,
        switchInCurve: AppMotion.emphasized,
        switchOutCurve: AppMotion.decelerate,
        transitionBuilder: (child, animation) {
          return AppMotion.tabTransition(animation: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _pages[_index],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.78),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.9),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: _onSelect,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                height: 68,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(AppIcons.homeOutline),
                    selectedIcon: Icon(AppIcons.home),
                    label: 'Ana Sayfa',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.alarmOutline),
                    selectedIcon: Icon(AppIcons.alarm),
                    label: 'Alarmlar',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.historyOutline),
                    selectedIcon: Icon(AppIcons.history),
                    label: 'Geçmiş',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.settingsOutline),
                    selectedIcon: Icon(AppIcons.settings),
                    label: 'Ayarlar',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
