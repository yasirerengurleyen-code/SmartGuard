import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/alarm_item.dart';
import '../../providers/alarms_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_background.dart';
import '../../widgets/premium_icon.dart';
import '../../widgets/section_header.dart';
import 'alarm_editor_sheet.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

  Future<void> _openEditor(
    BuildContext context, {
    AlarmItem? alarm,
  }) async {
    final result = await showModalBottomSheet<AlarmItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AlarmEditorSheet(alarm: alarm),
    );

    if (result == null || !context.mounted) return;

    final provider = context.read<AlarmsProvider>();
    if (alarm == null) {
      provider.addAlarm(result);
    } else {
      provider.updateAlarm(result);
    }
  }

  Future<void> _confirmDelete(BuildContext context, AlarmItem alarm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarmı Sil'),
        content: Text('"${alarm.title}" silinsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AlarmsProvider>().deleteAlarm(alarm.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alarms = context.watch<AlarmsProvider>().alarms;

    return PageBackground(
      child: SafeArea(
        bottom: false,
        child: ResponsiveLayout(
          child: Column(
            children: [
              const SizedBox(height: 12),
              SectionHeader(
                title: 'Alarmlar',
                subtitle: '${alarms.length} alarm tanımlı',
                action: IconButton.filledTonal(
                  onPressed: () => _openEditor(context),
                  icon: const Icon(AppIcons.add),
                  tooltip: 'Alarm Ekle',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: alarms.isEmpty
                    ? ListView(
                        children: [
                          EmptyState(
                            icon: AppIcons.alarmOutline,
                            title: 'Alarm yok',
                            message:
                                'Yeni bir alarm ekleyerek güvenlik zamanlaması oluşturun.',
                            action: FilledButton.icon(
                              onPressed: () => _openEditor(context),
                              icon: const Icon(AppIcons.add),
                              label: const Text('Alarm Ekle'),
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: alarms.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final alarm = alarms[index];
                          return _AlarmTile(
                            alarm: alarm,
                            onToggle: () => context
                                .read<AlarmsProvider>()
                                .toggleAlarm(alarm.id),
                            onEdit: () => _openEditor(context, alarm: alarm),
                            onDelete: () => _confirmDelete(context, alarm),
                          );
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

class _AlarmTile extends StatelessWidget {
  const _AlarmTile({
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final AlarmItem alarm;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(alarm.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(AppIcons.delete, color: AppColors.danger),
      ),
      child: GlassCard(
        onTap: onEdit,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alarm.formattedTime,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: alarm.enabled
                              ? null
                              : AppColors.textTertiaryDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alarm.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alarm.daysLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                  ),
                  if (alarm.note != null && alarm.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      alarm.note!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textTertiaryDark,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                Switch.adaptive(
                  value: alarm.enabled,
                  onChanged: (_) => onToggle(),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(AppIcons.delete),
                  color: AppColors.danger,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
