import 'config_parser.dart';
import 'package_config.dart';
import 'theme_config.dart';

bool isProdBuild = false;

class Config {
  static late String baseUrl;
  static late String appName;
  static late PackageConfig _packageConfig;
  static late ThemeConfig _themeConfig;
  static bool _hasThemeConfig = false;

  // For QA builds - store all available environments
  static Map<String, PackageConfig>? _allEnvironments;
  static bool _allowEnvironmentSwitching = false;

  // Timeout as const for use in const constructors, will be updated during initialization
  static const int timeoutSeconds = 20;

  // Default values
  static const String _defaultAppName = 'Elivaas';

  /// Initialize configuration from JSON string provided by the application layer (Production mode)
  /// All JSON parsing and validation happens here in the package
  static Future<void> initializeWithJsonConfig(String jsonConfigString, {String? themeJsonString}) async {
    try {
      // Parse configuration using the config parser
      _packageConfig = ConfigParser.parseConfiguration(jsonConfigString);
      _allowEnvironmentSwitching = false;
      _allEnvironments = null;

      // Initialize theme configuration if provided
      if (themeJsonString != null) {
        _themeConfig = ThemeConfig.fromJsonString(themeJsonString);
        _hasThemeConfig = true;
      }

      // Set static properties for backward compatibility
      _updateConfigProperties();
    } catch (e) {
      throw Exception('Failed to initialize configuration: $e');
    }
  }

  /// Initialize with multiple environments for QA testing (Development/Staging builds)
  /// Allows runtime environment switching via dummy_setting_screen
  static Future<void> initializeWithMultipleEnvironments(
    Map<String, String> environmentConfigs,
    String currentEnvironment, {
    String? themeJsonString,
  }) async {
    try {
      _allEnvironments = {};
      _allowEnvironmentSwitching = true;

      // Parse all environment configurations
      for (final entry in environmentConfigs.entries) {
        _allEnvironments![entry.key] = ConfigParser.parseConfiguration(entry.value);
      }

      // Set current environment
      if (_allEnvironments!.containsKey(currentEnvironment)) {
        _packageConfig = _allEnvironments![currentEnvironment]!;
      } else {
        throw Exception('Current environment "$currentEnvironment" not found in provided configurations');
      }

      // Initialize theme configuration if provided
      if (themeJsonString != null) {
        _themeConfig = ThemeConfig.fromJsonString(themeJsonString);
        _hasThemeConfig = true;
      }

      _updateConfigProperties();
    } catch (e) {
      throw Exception('Failed to initialize multi-environment configuration: $e');
    }
  }

  /// Switch to a different environment (only available in QA builds)
  static Future<void> switchEnvironment(String environmentName) async {
    if (!_allowEnvironmentSwitching) {
      throw Exception('Environment switching is not allowed in production builds');
    }

    if (_allEnvironments == null || !_allEnvironments!.containsKey(environmentName)) {
      throw Exception('Environment "$environmentName" is not available');
    }

    _packageConfig = _allEnvironments![environmentName]!;
    _updateConfigProperties();
  }

  /// Update static properties when environment changes
  static void _updateConfigProperties() {
    baseUrl = _packageConfig.api.baseUrl;
    appName = ConfigParser.generateAppName(_defaultAppName, _packageConfig.environment);
  }

  /// Get the current environment name
  static String get environment => _packageConfig.environment;

  /// Get feature configuration
  static FeatureConfig get features => _packageConfig.features;

  /// Check if debug panel is enabled
  static bool get isDebugPanelEnabled => _packageConfig.features.enableDebugPanel;

  /// Check if environment badge should be shown
  static bool get shouldShowEnvironmentBadge => _packageConfig.features.showEnvironmentBadge;

  /// Check if environment switching is allowed (QA builds only)
  static bool get canSwitchEnvironments => _allowEnvironmentSwitching;

  /// Get all available environment names for switching
  static List<String> get availableEnvironments => _allEnvironments?.keys.toList() ?? [];

  /// Get the current theme configuration
  static ThemeConfig get themeConfig => _themeConfig;

  /// Check if theme configuration is initialized
  static bool get hasThemeConfig => _hasThemeConfig;
}
