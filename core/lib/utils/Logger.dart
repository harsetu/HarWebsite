import 'package:flutter/foundation.dart';

class Logger {
  static void _log(String level, Object message) {
    if (!kDebugMode) return;

    final trace = StackTrace.current.toString().split('\n')[2]; // Adjusted index for correct caller
    final regex = RegExp(r'#2\s+.*\((.*?):(\d+):\d+\)');
    final match = regex.firstMatch(trace);

    final location = match != null ? '${match.group(1)}: Line ${match.group(2)}' : 'unknown';
    final logMessage = '[$level] [$location] $message';

    if (kDebugMode) {
      print(logMessage);
    }
  }

  static void info(Object? message) => _log('INFO', message ?? "NULL");

  static void warning(Object? message) => _log('WARNING', message ?? "NULL");

  static void error(Object? message) => _log('ERROR', message ?? "NULL");

  static void debug(Object? message) => _log('DEBUG', message ?? "NULL");
}
