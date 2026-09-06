import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static Future<void> saveValue(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else {
      throw Exception('Unsupported value type');
    }
  }

  static Future<T?> getValue<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(key)) {
      return null;
    }

    try {
      if (T == String) {
        return prefs.getString(key) as T;
      } else if (T == int) {
        return prefs.getInt(key) as T;
      } else if (T == double) {
        return prefs.getDouble(key) as T;
      } else if (T == bool) {
        return prefs.getBool(key) as T;
      }
    } catch (e) {
      // Return null for type mismatches - let the caller handle it
      return null;
    }
    return null;
  }

  // User-specific methods
  static Future<void> saveModel<T>(
    T model,
    String key,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    final jsonString = jsonEncode(toJson(model));
    await saveValue(key, jsonString);
  }

  static Future<T?> getModel<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final jsonString = await getValue<String>(key);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
