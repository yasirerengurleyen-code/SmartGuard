import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history_event.dart';
import '../../providers/history_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatters.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_background.dart';
import '../../widgets/premium_icon.dart';
import '../../widgets/section_header.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryEventType? _filter;

  @override
  Widget build(BuildContext context) {
    final all = context.watch<HistoryProvider>().events;
    final events = _filter == null
        ? all
        : _filter == HistoryEventType.systemArmed
            ? all
                .where(
                  (e) =>
                      e.type == HistoryEventType.systemArmed ||
                      e.type == HistoryEventType.systemDisarmed,
                )
                .toList(growable: false)
            : all.where((e) => e.type == _filter).toList(growable: false);

    return PageBackground(
      child: SafeArea(
        bottom: false,
        child: ResponsiveLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              SectionHeader(
                title: 'Geçmiş',
                subtitle: 'Alarm ve hareket kayıtları',
                action: all.isEmpty
                    ? null
                    : TextButton(
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Geçmişi Temizle'),
                              content: const Text(
                                'Tüm kayıtlar silinsin mi?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Vazgeç'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Temizle'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) {
                            context.read<HistoryProvider>().clear();
                          }
                        },
                        child: const Text('Temizle'),
                      ),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Tümü',
                      selected: _filter == null,
                      onTap: () => setState(() => _filter = null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Alarm',
                      selected: _filter == HistoryEventType.alarmTriggered,
                      onTap: () => setState(
                        () => _filter = HistoryEventType.alarmTriggered,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Hareket',
                      selected: _filter == HistoryEventType.motionDetected,
                      onTap: () => setState(
                        () => _filter = HistoryEventType.motionDetected,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Sistem',
                      selected: _filter == HistoryEventType.systemArmed ||
                          _filter == HistoryEventType.systemDisarmed,
                      onTap: () => setState(
                        () => _filter = HistoryEventType.systemArmed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: events.isEmpty
                    ? ListView(
                        children: const [
                          EmptyState(
                            icon: AppIcons.history,
                            title: 'Kayıt yok',
                            message:
                                'Alarm ve hareket olayları burada listelenecek.',
                          ),
                        ],
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _HistoryTile(event: events[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.accent,
      labelStyle: TextStyle(
        color: selected ? AppColors.voidBlack : AppColors.textSecondaryDark,
        fontWeight: FontWeight.w600,
      ),
      checkmarkColor: AppColors.voidBlack,
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.event});

  final HistoryEvent event;

  Color get _accent {
    switch (event.type) {
      case HistoryEventType.alarmTriggered:
        return AppColors.danger;
      case HistoryEventType.motionDetected:
        return AppColors.warning;
      case HistoryEventType.systemArmed:
        return AppColors.success;
      case HistoryEventType.systemDisarmed:
        return AppColors.info;
    }
  }

  IconData get _icon {
    switch (event.type) {
      case HistoryEventType.alarmTriggered:
        return AppIcons.bell;
      case HistoryEventType.motionDetected:
        return AppIcons.sensors;
      case HistoryEventType.systemArmed:
        return AppIcons.shield;
      case HistoryEventType.systemDisarmed:
        return AppIcons.shieldOutline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          PremiumIcon(
            icon: _icon,
            size: 46,
            color: _accent,
            radius: 14,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (event.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    event.subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DateFormatters.relative(event.timestamp),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
          ),
        ],
      ),
    );
  }
}
