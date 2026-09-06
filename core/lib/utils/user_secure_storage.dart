import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _userDataKey = 'user_basic_info';

  /// Save basic user data to secure storage
  static Future<void> saveModel<T>(
      T model,
      String key,
      String Function(T) toJsonString,
      ) async {
    try {
      final jsonString = toJsonString(model);
      await _storage.write(key: key, value: jsonString);
    } catch (e) {
      // Handle error silently or log if needed
    }
  }

  static Future<T?> getModel<T>(
      String key,
      T Function(String) fromJsonString,
      ) async {
    try {
      final jsonString = await _storage.read(key: key);
      if (jsonString != null && jsonString.isNotEmpty) {
        return fromJsonString(jsonString);
      }
    } catch (e) {
      // Handle error silently or log if needed
    }
    return null;
  }

  /// Clear user data from secure storage
  static Future<void> clearUserData() async {
    try {
      await _storage.delete(key: _userDataKey);
    } catch (e) {
      // Handle error silently or log if needed
    }
  }

  /// Check if user data exists
  static Future<bool> hasUserData() async {
    try {
      final jsonString = await _storage.read(key: _userDataKey);
      return jsonString != null && jsonString.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}