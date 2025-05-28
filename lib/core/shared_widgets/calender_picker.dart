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
          color: Colors.black,
          fontWeight: FontWeight.w400,
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
          color: Colors.black,
        ), // Same text style as default
        selectedTextStyle: TextStyle(color: Colors.white),
        defaultTextStyle: TextStyle(color: Colors.black),
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
