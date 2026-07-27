abstract final class DateFormatters {
  static const _months = <String>[
    'Oca',
    'Şub',
    'Mar',
    'Nis',
    'May',
    'Haz',
    'Tem',
    'Ağu',
    'Eyl',
    'Eki',
    'Kas',
    'Ara',
  ];

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String timeOnly(DateTime date) =>
      '${_two(date.hour)}:${_two(date.minute)}';

  static String relativeFallback(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} · ${timeOnly(date)}';

  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Az önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24 && now.day == date.day) {
      return 'Bugün · ${timeOnly(date)}';
    }
    if (diff.inHours < 48 &&
        now.subtract(const Duration(days: 1)).day == date.day) {
      return 'Dün · ${timeOnly(date)}';
    }
    return relativeFallback(date);
  }
}
