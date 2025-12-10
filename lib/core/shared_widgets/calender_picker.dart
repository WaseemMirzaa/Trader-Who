import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:traderou/core/theme/app_color.dart';

class CalendarPicker extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime>? jobDates; // List of dates that have jobs

  const CalendarPicker({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.jobDates,
  });

  @override
  State<CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<CalendarPicker> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = widget.selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(CalendarPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDay = widget.selectedDate;
    }
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasJobsOnDate(DateTime date) {
    if (widget.jobDates == null) return false;
    return widget.jobDates!.any((jobDate) => _isSameDay(jobDate, date));
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<DateTime>(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected?.call(selectedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      headerVisible: true,
      calendarFormat: CalendarFormat.month,
      rowHeight: 36,
      sixWeekMonthsEnforced: true,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColor.darkGrayTextCalender,
        ),
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left_outlined,
          color: Colors.black,
          size: 24,
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right_outlined,
          color: Colors.black,
          size: 24,
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        weekendStyle: TextStyle(
          color: AppColor.primaryText,
          fontWeight: FontWeight.w400,
          fontFamily: 'openSans',
          fontSize: 12,
        ),
      ),
      calendarStyle: const CalendarStyle(
        // Remove highlight for today
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent, // No background for today
        ),
        selectedDecoration: BoxDecoration(
          color: AppColor.darkBlue,
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(shape: BoxShape.circle),
        todayTextStyle: TextStyle(
          color: AppColor.primaryText,
          fontFamily: 'openSans',
        ), // Same text style as default
        selectedTextStyle: TextStyle(color: Colors.white),
        defaultTextStyle: TextStyle(color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          // Show indicator for dates with jobs
          if (_hasJobsOnDate(day)) {
            return Container(
              margin: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    _isSameDay(_selectedDay, day)
                        ? AppColor.darkBlue
                        : AppColor.orangeCustomColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color:
                      _isSameDay(_selectedDay, day)
                          ? Colors.white
                          : Colors.black,
                  fontSize: 12,
                ),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, day, focusedDay) {
          // Custom today indicator
          return Container(
            margin: const EdgeInsets.all(2.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  _isSameDay(_selectedDay, day)
                      ? AppColor.darkBlue
                      : (_hasJobsOnDate(day)
                          ? AppColor.orangeCustomColor.withValues(alpha: 0.3)
                          : Colors.transparent),
              shape: BoxShape.circle,
              border:
                  _isSameDay(_selectedDay, day)
                      ? null
                      : Border.all(color: AppColor.darkBlue, width: 1),
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(
                color:
                    _isSameDay(_selectedDay, day)
                        ? Colors.white
                        : AppColor.darkBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }
}
