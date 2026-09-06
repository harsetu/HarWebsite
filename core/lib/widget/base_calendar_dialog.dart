import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

import '../../constants/color_manager.dart';

class BaseCalendarDialog {
  DateTime today = DateTime.now();

  DateTime defaultStartDate = DateTime(DateTime.now().year - 100);

  CalendarDatePicker2WithActionButtonsConfig getConfig(BuildContext context, [DateTime? startDate, DateTime? endDate]) {
    ThemeData themeData = Theme.of(context);
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: themeData.textTheme.bodySmall,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: ColorManager.primaryColor,
      selectedYearTextStyle: TextStyle(color: ColorManager.colorWhite),
      selectedMonthTextStyle: TextStyle(color: ColorManager.colorWhite),
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      firstDate: startDate ?? defaultStartDate,
      lastDate: endDate ?? today,
      weekdayLabelTextStyle: themeData.textTheme.headlineSmall,
      controlsTextStyle: themeData.textTheme.headlineMedium,
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: themeData.textTheme.bodySmall?.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          textStyle = themeData.textTheme.bodyMedium;
        }
        return textStyle;
      },
    );
  }

  Future<DateTime> showCalendar(BuildContext context, [DateTime? startData, DateTime? endDate]) async {
    List<DateTime?>? dateTime = await showCalendarDatePicker2Dialog(
      context: context,
      config: getConfig(context, startData, endDate),
      dialogSize: const Size(325, 370),
      borderRadius: BorderRadius.circular(15),
      value: [today],
      dialogBackgroundColor: Colors.white,
    );
    return dateTime?.first ?? today;
  }
}
