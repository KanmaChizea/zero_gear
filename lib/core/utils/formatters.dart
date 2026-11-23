String groupThousands(String digits) =>
    digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

/// Adds thousand separators to a number, e.g. 1234567 to "1,234,567".
String formatNumber(int number) => groupThousands(number.toString());

const _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats [date] like "8 Oct 2026".
String formatShortDate(DateTime date) =>
    '${date.day} ${_shortMonths[date.month - 1]} ${date.year}';

/// Formats [date] like "8 Oct".
String formatDayMonth(DateTime date) =>
    '${date.day} ${_shortMonths[date.month - 1]}';
