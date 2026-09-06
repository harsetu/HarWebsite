import 'package:flutter/services.dart';

/// A UPI-capable app installed on the device, as reported by
/// [UpiNativeService.getUpiApps].
class UpiAppInfo {
  final String packageName;
  final String name;
  final Uint8List? icon;

  const UpiAppInfo({required this.packageName, required this.name, this.icon});

  factory UpiAppInfo.fromMap(Map<dynamic, dynamic> map) {
    return UpiAppInfo(
      packageName: map['packageName'] as String? ?? '',
      name: map['name'] as String? ?? '',
      icon: map['icon'] as Uint8List?,
    );
  }
}

/// Android-only native bridge (see `MainActivity.kt`) that lets the guest
/// pick which installed UPI app to pay with, then launches that specific
/// app — rather than firing a generic `upi://pay` intent and letting the OS
/// silently resolve to a single/default handler.
class UpiNativeService {
  UpiNativeService._();

  static const MethodChannel _channel = MethodChannel(
    'com.harsetu.connect/upi',
  );

  static Future<List<UpiAppInfo>> getUpiApps() async {
    final apps = await _channel.invokeMethod<List<dynamic>>('getUpiApps');
    if (apps == null) return const [];
    return apps
        .map((app) => UpiAppInfo.fromMap(Map<dynamic, dynamic>.from(app as Map)))
        .toList();
  }

  static Future<bool> launchUpiApp({
    required String packageName,
    required String uri,
  }) async {
    final launched = await _channel.invokeMethod<bool>('launchUpiApp', {
      'packageName': packageName,
      'uri': uri,
    });
    return launched ?? false;
  }
}
