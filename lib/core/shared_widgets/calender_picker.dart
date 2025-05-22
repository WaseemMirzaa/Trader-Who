import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:traderwho/core/theme/app_color.dart';

class CalendarPicker extends StatelessWidget {
  const CalendarPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      headerVisible: true,
      calendarFormat: CalendarFormat.month,
      rowHeight: 36,
      sixWeekMonthsEnforced: true,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        leftChevronIcon: const Icon(
          Icons.keyboard_arrow_left_outlined,
          color: Colors.black,
          size: 24,
        ),
        rightChevronIcon: const Icon(
          Icons.keyboard_arrow_right_outlined,
          color: Colors.black,
          size: 24,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        weekendStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: AppColor.darkBlue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColor.darkBlue,
          shape: BoxShape.circle,
        ),
        defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
        todayTextStyle: const TextStyle(color: Colors.white),
        selectedTextStyle: const TextStyle(color: Colors.white),
        defaultTextStyle: const TextStyle(color: Colors.black),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (day.day == 4 || day.day == 5) {
            return Container(
              margin: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColor.darkBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
