import 'package:flutter/material.dart';

import '../../models/alarm_item.dart';
import '../../theme/app_colors.dart';
import '../../utils/constants.dart';

class AlarmEditorSheet extends StatefulWidget {
  const AlarmEditorSheet({super.key, this.alarm});

  final AlarmItem? alarm;

  @override
  State<AlarmEditorSheet> createState() => _AlarmEditorSheetState();
}

class _AlarmEditorSheetState extends State<AlarmEditorSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  late TimeOfDay _time;
  late bool _enabled;
  late List<int> _days;

  static const _dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

  bool get _isEditing => widget.alarm != null;

  @override
  void initState() {
    super.initState();
    final alarm = widget.alarm;
    _titleController = TextEditingController(text: alarm?.title ?? '');
    _noteController = TextEditingController(text: alarm?.note ?? '');
    _time = alarm?.time ?? const TimeOfDay(hour: 8, minute: 0);
    _enabled = alarm?.enabled ?? true;
    _days = List<int>.from(alarm?.days ?? const [1, 2, 3, 4, 5]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _toggleDay(int day) {
    setState(() {
      if (_days.contains(day)) {
        if (_days.length > 1) _days.remove(day);
      } else {
        _days.add(day);
        _days.sort();
      }
    });
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alarm başlığı gerekli')),
      );
      return;
    }

    final result = AlarmItem(
      id: widget.alarm?.id,
      title: title,
      time: _time,
      enabled: _enabled,
      days: _days,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.pagePadding,
          12,
          AppConstants.pagePadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerDark,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              _isEditing ? 'Alarmı Düzenle' : 'Alarm Ekle',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                hintText: 'Örn. Gece Modu',
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _pickTime,
              borderRadius: BorderRadius.circular(14),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Saat',
                  suffixIcon: Icon(Icons.access_time_rounded),
                ),
                child: Text(
                  '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Günler',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(7, (index) {
                final day = index + 1;
                final selected = _days.contains(day);
                return FilterChip(
                  selected: selected,
                  label: Text(_dayLabels[index]),
                  onSelected: (_) => _toggleDay(day),
                  selectedColor: AppColors.accent,
                  checkmarkColor: AppColors.voidBlack,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.voidBlack
                        : AppColors.textSecondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Not (opsiyonel)',
                hintText: 'Kısa açıklama',
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Alarm aktif'),
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                child: Text(_isEditing ? 'Kaydet' : 'Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
