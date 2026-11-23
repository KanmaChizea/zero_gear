import 'package:flutter/material.dart';
import 'package:zero_gear/core/constants/app_svgs.dart';
import 'package:zero_gear/core/extensions/date_extensions.dart';
import 'package:zero_gear/core/router/app_route.dart';
import 'package:zero_gear/core/theme/theme.dart';
import 'package:zero_gear/core/utils/formatters.dart';
import 'package:zero_gear/core/utils/scale_util.dart';
import 'package:zero_gear/core/widgets/text/app_text.dart';
import 'package:zero_gear/features/home/data/models/workout_status.dart';
import 'package:zero_gear/features/home/ui/widgets/home/calendar_day_cell.dart';
import 'package:zero_gear/features/home/ui/widgets/home/calendar_legend_item.dart';
import 'package:zero_gear/features/home/ui/widgets/home/calendar_month_button.dart';
import 'package:zero_gear/features/home/ui/widgets/home/calendar_week_row.dart';

class ProgressCalendar extends StatefulWidget {
  const ProgressCalendar({
    super.key,
    required this.data,
    required this.startDate,
  });

  final Map<DateTime, WorkoutStatus> data;
  final DateTime startDate;

  @override
  State<ProgressCalendar> createState() => _ProgressCalendarState();
}

class _ProgressCalendarState extends State<ProgressCalendar> {
  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  late final DateTime _today = DateTime.now().dateOnly;
  late DateTime _month = DateTime(_today.year, _today.month);

  DateTime get _earliestMonth =>
      DateTime(widget.startDate.year, widget.startDate.month);

  bool get _canGoBack => _month.isAfter(_earliestMonth);
  bool get _canGoForward =>
      _month.isBefore(DateTime(_today.year, _today.month));

  void _shift(int months) =>
      setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final statuses = {
      for (final e in widget.data.entries) e.key.dateOnly: e.value,
    };
    final leading = _month.weekday - 1;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final weeks = ((leading + daysInMonth) / 7).ceil();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(width: 1.5, color: colors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CalendarMonthButton(
                asset: AppSvgs.chevronLeft,
                onTap: _canGoBack ? () => _shift(-1) : null,
              ),
              Expanded(
                child: AppText(
                  formatMonthYear(_month),
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                ),
              ),
              CalendarMonthButton(
                asset: AppSvgs.chevronRight,
                onTap: _canGoForward ? () => _shift(1) : null,
              ),
            ],
          ),
          AppSpacing.v12,
          CalendarWeekRow(
            children: [
              for (final day in _weekdays)
                AppText(
                  day,
                  style: AppTextStyles.caption,
                  color: colors.textSecondary,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          for (var week = 0; week < weeks; week++) ...[
            AppSpacing.v12,
            CalendarWeekRow(
              children: [
                for (var weekday = 0; weekday < 7; weekday++)
                  _dayCell(
                    week * 7 + weekday - leading + 1,
                    daysInMonth,
                    statuses,
                  ),
              ],
            ),
          ],
          AppSpacing.v12,
          Row(
            children: [
              const CalendarLegendItem(
                label: 'Workout completed',
                filled: true,
              ),
              AppSpacing.h12,
              const CalendarLegendItem(
                label: 'Workout incomplete',
                filled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayCell(
    int day,
    int daysInMonth,
    Map<DateTime, WorkoutStatus> statuses,
  ) {
    if (day < 1 || day > daysInMonth) return const SizedBox.shrink();
    final date = DateTime(_month.year, _month.month, day);
    return CalendarDayCell(
      day: day,
      status: statuses[date],
      isToday: date == _today,
      onTap: date.isAfter(_today)
          ? null
          : () => context.pushNamed(
              AppRoute.workoutRecord.name,
              pathParameters: {'date': date.toIso8601String().substring(0, 10)},
            ),
    );
  }
}
