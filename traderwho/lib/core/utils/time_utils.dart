import 'package:flutter/material.dart';

/// A [TimeUtils] class for handling time-related operations.
class TimeUtils {
  ///[showTimePickerDialog] shows a time picker dialog and returns the selected time as a string.
  static Future<String?> showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
    Color? primaryColor,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor ?? Theme.of(context).primaryColor,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
    return null;
  }

  ///[parseTimeString] parses a time string in the format "HH:mm" and returns a [TimeOfDay] object.

  static TimeOfDay? parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      return null;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
