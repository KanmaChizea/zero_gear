extension DateOnlyExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  String get isoDate =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';

  DateTime get startOfWeek => DateTime(year, month, day - (weekday - 1));

  int daysSince(DateTime other) => DateTime.utc(
    year,
    month,
    day,
  ).difference(DateTime.utc(other.year, other.month, other.day)).inDays;
}
