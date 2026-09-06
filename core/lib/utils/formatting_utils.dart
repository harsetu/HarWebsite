import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/date_format_constants.dart';
import '../constants/localization_keys.dart';

class FormattingUtils {
  static String getLocalizeString(BuildContext context, String key, [List<String>? args, bool isLocalizeText = true]) {
    if (!isLocalizeText) {
      return key;
    }
    // Passing `context` registers this call site as a dependent of the
    // Localizations InheritedWidget, so it rebuilds when the locale changes
    // via `context.setLocale()`. Without it, `.tr()` reads a global static
    // singleton and the text only updates on the widget's next unrelated
    // rebuild.
    if (args != null && args.isNotEmpty) {
      return key.tr(context: context, args: args);
    }

    return key.tr(context: context);
  }

  static bool isGenricErrorErrorConstant(String key) {
    return (key == LocalizationKeys.genericErrorLabel);
  }

  static String formatDate(DateTime date, {String format = DateFormatConstants.yyyymmdd}) {
    return DateFormat(format).format(date);
  }

  static String parseDate(String dateString, {String format = DateFormatConstants.iso8601, String outputFormat = DateFormatConstants.ddMMMyyyyhhmmA}) {
    try {
      return DateFormat(outputFormat).format(DateFormat(format).parse(dateString));
    } catch (e) {
      debugPrint('Error parsing date: $dateString with format: $format - $e');
      return '';
    }
  }
}
