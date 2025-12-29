import 'package:flutter/material.dart';
import 'package:traderou/core/shared_widgets/custom_time_picker.dart';

/// A [TimeUtils] class for handling time-related operations.
class TimeUtils {
  ///[showTimePickerDialog] shows a time picker dialog and returns the selected time as a string.
  static Future<String?> showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
    Color? primaryColor,
  }) async {
    final TimeOfDay? picked = await showCustomTimePicker(
      context: context,
      initialTime: initialTime,
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
