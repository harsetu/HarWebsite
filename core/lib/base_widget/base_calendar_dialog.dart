import 'package:flutter/material.dart';

class BaseCalendarDialog {
  /// [firstSelectableDate] restricts the picker to that date and later (e.g.
  /// pass today's date to disallow picking a past date). Defaults to no
  /// restriction.
  Future<DateTime> showCalendar(BuildContext context, {DateTime? firstSelectableDate}) async {
    final now = DateTime.now();
    final effectiveFirstDate = firstSelectableDate ?? DateTime(1900);
    final initialDate = now.isBefore(effectiveFirstDate) ? effectiveFirstDate : now;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: effectiveFirstDate,
      lastDate: DateTime(2100),
    );
    return picked ?? initialDate;
  }

  /// Shows a date picker followed by a time picker and combines the results.
  Future<DateTime> showDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !context.mounted) return DateTime.now();

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return pickedDate;

    return DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
  }

  /// Shows a time picker only.
  Future<TimeOfDay> showTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return pickedTime ?? TimeOfDay.now();
  }
}
