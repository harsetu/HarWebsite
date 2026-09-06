import 'dart:convert';

/// Configuration models for the hk_package
/// These handle all JSON parsing and validation logic

class PackageConfig {
  final String environment;
  final ApiConfig api;
  final FeatureConfig features;

  PackageConfig({required this.environment, required this.api, required this.features});

  /// Parse configuration from raw JSON string
  factory PackageConfig.fromJson(Map<String, dynamic> json) {
    try {
      return PackageConfig(
        environment: json['environment'] as String? ?? 'unknown',
        api: ApiConfig.fromJson(json['api'] as Map<String, dynamic>? ?? {}),
        features: FeatureConfig.fromJson(json['features'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      throw Exception('Failed to parse PackageConfig from JSON: $e');
    }
  }

  /// Parse configuration directly from JSON string
  static PackageConfig fromJsonString(String jsonString) {
    try {
      final dynamic parsed = jsonDecode(jsonString);
      if (parsed is Map<String, dynamic>) {
        return PackageConfig.fromJson(parsed);
      } else {
        throw Exception('JSON string does not contain a valid object');
      }
    } catch (e) {
      throw Exception('Failed to parse JSON string: $e');
    }
  }
}

class ApiConfig {
  final String baseUrl;
  final int timeoutSeconds;

  ApiConfig({required this.baseUrl, this.timeoutSeconds = 20});

  factory ApiConfig.fromJson(Map<String, dynamic> json) {
    return ApiConfig(baseUrl: json['base_url'] as String? ?? '', timeoutSeconds: json['timeout_seconds'] as int? ?? 20);
  }
}

class FeatureConfig {
  final bool enableDebugPanel;
  final bool showEnvironmentBadge;
  final bool enableApplyLeavePhase2;

  FeatureConfig({this.enableDebugPanel = false, this.showEnvironmentBadge = false, this.enableApplyLeavePhase2 = true});

  factory FeatureConfig.fromJson(Map<String, dynamic> json) {
    return FeatureConfig(
      enableDebugPanel: json['enable_debug_panel'] as bool? ?? false,
      showEnvironmentBadge: json['show_environment_badge'] as bool? ?? false,
      enableApplyLeavePhase2: json['enable_apply_leave_phase2'] as bool? ?? true,
    );
  }
}
