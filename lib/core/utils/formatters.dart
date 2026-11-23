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

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Formats [date] like "November 2026".
String formatMonthYear(DateTime date) =>
    '${_months[date.month - 1]} ${date.year}';

const _ones = [
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
];

const _tens = [
  '',
  '',
  'twenty',
  'thirty',
  'forty',
  'fifty',
  'sixty',
  'seventy',
  'eighty',
  'ninety',
];

const _scales = [
  (1000000000, 'billion'),
  (1000000, 'million'),
  (1000, 'thousand'),
  (100, 'hundred'),
];

/// Spells out [number], e.g. 1 to "One" and 42 to "Forty-two".
String numberToWords(int number) {
  final words = _spell(number.abs());
  final text = number < 0 ? 'minus $words' : words;
  return text[0].toUpperCase() + text.substring(1);
}

String _spell(int n) {
  if (n < 20) return _ones[n];
  if (n < 100) {
    final ones = n % 10;
    return ones == 0 ? _tens[n ~/ 10] : '${_tens[n ~/ 10]}-${_ones[ones]}';
  }
  for (final (value, name) in _scales) {
    if (n >= value) {
      final rest = n % value;
      final head = '${_spell(n ~/ value)} $name';
      return rest == 0 ? head : '$head ${_spell(rest)}';
    }
  }
  return n.toString();
}

/// Formats the time of day like "8:30 PM".
String formatTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${time.hour < 12 ? 'AM' : 'PM'}';
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Formats [date] like "THURSDAY 19 NOVEMBER".
String formatWeekdayDayMonth(DateTime date) =>
    '${_weekdays[date.weekday - 1]} ${date.day} ${_months[date.month - 1]}'
        .toUpperCase();
