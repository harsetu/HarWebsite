import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final storage = const FlutterSecureStorage();

  // Generic store method
  Future<void> store(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } on PlatformException catch (e) {
      if (e.code == 'kInsufficientStorageSpace') {
        // Handle the case where the user denies permission to use the secure storage
      } else {
        // Handle other errors
      }
    } catch (e) {
      // Handle other errors
    }
  }

  // Generic get method
  Future<String?> get(String key) async {
    try {
      final value = await storage.read(key: key);
      return value;
    } on PlatformException {
      // Handle other errors
    } on Exception {
      // Handle other errors
    }
    return null;
  }

  // Backward compatibility methods (deprecated)
  @Deprecated('Use store(key, value) instead')
  Future<void> storeAccessToken(String token, String key) async {
    await store(key, token);
  }

  @Deprecated('Use get(key) instead')
  Future<String?> getAccessToken(String key) async {
    return await get(key);
  }

  // Delete a value from the Flutter Secure storage
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  // Delete all values from the Flutter Secure storage
  Future<void> deleteAll() async {
    await storage.deleteAll();
  }
}
