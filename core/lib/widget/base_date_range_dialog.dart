import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/app_text_styles.dart';
import '../constants/color_manager.dart';
import '../constants/date_format_constants.dart';
import '../constants/localization_keys.dart';
import '../utils/formatting_utils.dart';
import 'base_button.dart';
import 'base_text_view.dart';

DateTime _todayAtMidnight() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// Opens a single calendar in range-selection mode so a start/end pair (e.g.
/// check-in/check-out) is picked in one interaction and backed by one field,
/// instead of two separate single-date pickers. Defaults to disallowing past
/// dates; pass [unavailableDaysLoader] to grey out specific days (e.g. fully
/// booked ones) per visible month.
class BaseDateRangeDialog {
  Future<DateTimeRange?> showRange(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    Future<Set<DateTime>> Function(DateTime month)? unavailableDaysLoader,
  }) {
    final resolvedFirstDate = firstDate ?? _todayAtMidnight();
    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _DateRangeSheet(
        firstDate: resolvedFirstDate,
        lastDate: lastDate ?? resolvedFirstDate.add(const Duration(days: 365)),
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        unavailableDaysLoader: unavailableDaysLoader,
      ),
    );
  }
}

class _DateRangeSheet extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Future<Set<DateTime>> Function(DateTime month)? unavailableDaysLoader;

  const _DateRangeSheet({
    required this.firstDate,
    required this.lastDate,
    this.initialStartDate,
    this.initialEndDate,
    this.unavailableDaysLoader,
  });

  @override
  State<_DateRangeSheet> createState() => _DateRangeSheetState();
}

class _DateRangeSheetState extends State<_DateRangeSheet> {
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  Set<DateTime> _unavailableDays = {};
  bool _isLoadingAvailability = false;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialStartDate;
    _rangeEnd = widget.initialEndDate;
    _focusedDay = widget.initialStartDate ?? widget.firstDate;
    _loadAvailability(_focusedDay);
  }

  Future<void> _loadAvailability(DateTime month) async {
    final loader = widget.unavailableDaysLoader;
    if (loader == null) return;
    setState(() => _isLoadingAvailability = true);
    final unavailableDays = await loader(month);
    if (!mounted) return;
    setState(() {
      _unavailableDays = unavailableDays;
      _isLoadingAvailability = false;
    });
  }

  bool _isDayEnabled(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    if (normalized.isBefore(widget.firstDate)) return false;
    return !_unavailableDays.contains(normalized);
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    if ((start != null && !_isDayEnabled(start)) ||
        (end != null && !_isDayEnabled(end))) {
      return;
    }
    setState(() {
      _rangeStart = start;
      _rangeEnd = end;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _rangeStart != null && _rangeEnd != null;
    final rangeLabel = _rangeStart == null
        ? null
        : _rangeEnd == null
            ? FormattingUtils.formatDate(
                _rangeStart!,
                format: DateFormatConstants.dayMonthYearSlash,
              )
            : '${FormattingUtils.formatDate(_rangeStart!, format: DateFormatConstants.dayMonthYearSlash)} '
                '- '
                '${FormattingUtils.formatDate(_rangeEnd!, format: DateFormatConstants.dayMonthYearSlash)}';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BaseTextView(
                  text: LocalizationKeys.selectDatesLabel,
                  style: AppTextStyles.h3,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: ColorManager.colorText70),
                ),
              ],
            ),
            if (rangeLabel != null) ...[
              const SizedBox(height: 4),
              BaseTextView(
                text: rangeLabel,
                isLocalizeText: false,
                useAutoTranslation: false,
                style: AppTextStyles.bodyRegular,
                textColor: ColorManager.colorText70,
              ),
            ],
            const SizedBox(height: 8),
            if (_isLoadingAvailability)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: LinearProgressIndicator(
                  color: ColorManager.primaryColor,
                  minHeight: 2,
                ),
              ),
            TableCalendar(
              firstDay: widget.firstDate,
              lastDay: widget.lastDate,
              focusedDay: _focusedDay,
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              enabledDayPredicate: _isDayEnabled,
              onRangeSelected: _onRangeSelected,
              onPageChanged: (focusedDay) {
                setState(() => _focusedDay = focusedDay);
                _loadAvailability(focusedDay);
              },
              calendarFormat: CalendarFormat.month,
              availableGestures: AvailableGestures.horizontalSwipe,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                rangeHighlightColor: ColorManager.primaryColor.withAlpha(40),
                withinRangeTextStyle: TextStyle(color: ColorManager.primaryColor),
                rangeStartDecoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: ColorManager.primaryColor.withAlpha(60),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                ),
                disabledTextStyle: TextStyle(color: ColorManager.colorBorder),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: BaseButton(
                buttonText: LocalizationKeys.doneLabel,
                isDisabled: !canConfirm,
                onPressed: () => Navigator.of(context).pop(
                  DateTimeRange(start: _rangeStart!, end: _rangeEnd!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
