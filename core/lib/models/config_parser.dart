import '../../models/package_config.dart';

/// Centralized configuration parser for the hk_package
/// Handles all JSON parsing, validation, and configuration logic
class ConfigParser {
  /// Parse and validate configuration from JSON string
  static PackageConfig parseConfiguration(String jsonConfigString) {
    if (jsonConfigString.trim().isEmpty) {
      throw Exception('Configuration JSON string cannot be empty');
    }

    try {
      final config = PackageConfig.fromJsonString(jsonConfigString);
      _validateConfiguration(config);
      return config;
    } catch (e) {
      throw Exception('Failed to parse configuration: $e');
    }
  }

  /// Validate that the configuration contains required fields
  static void _validateConfiguration(PackageConfig config) {
    if (config.api.baseUrl.trim().isEmpty) {
      throw Exception('API base URL cannot be empty in configuration');
    }

    if (!_isValidUrl(config.api.baseUrl)) {
      throw Exception('Invalid API base URL format: ${config.api.baseUrl}');
    }

    if (config.api.timeoutSeconds <= 0) {
      throw Exception('API timeout seconds must be greater than 0');
    }

    if (config.environment.trim().isEmpty) {
      throw Exception('Environment name cannot be empty in configuration');
    }
  }

  /// Simple URL validation
  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Generate app name based on environment and base app name
  static String generateAppName(String baseAppName, String environment) {
    switch (environment.toLowerCase()) {
      case 'staging':
        return '$baseAppName-Staging';
      case 'development':
      case 'dev':
        return '$baseAppName-Dev';
      case 'qa':
        return '$baseAppName-QA';
      case 'production':
      case 'prod':
      default:
        return baseAppName;
    }
  }
}
