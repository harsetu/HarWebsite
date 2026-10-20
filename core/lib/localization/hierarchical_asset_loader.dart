import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Custom asset loader that merges package-level and app-level translations
/// App-level translations take precedence over package-level translations
class HierarchicalAssetLoader extends AssetLoader {
  const HierarchicalAssetLoader();

  static const _supportedFiles = {'en_US.json', 'hi_IN.json', 'pa_IN.json'};

  static String _defaultCountryFor(String languageCode) {
    switch (languageCode) {
      case 'hi':
      case 'pa':
        return 'IN';
      default:
        return 'US';
    }
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    // Convert locale to the correct file naming format (e.g., en_US.json)
    // A locale can arrive without a country (e.g. a saved or browser-derived
    // `hi`), which would otherwise yield `hi_null.json` — resolve it to the
    // supported locale for that language, falling back to English.
    final countryCode = (locale.countryCode == null || locale.countryCode!.isEmpty)
        ? _defaultCountryFor(locale.languageCode)
        : locale.countryCode;
    var fileName = '${locale.languageCode}_$countryCode.json';
    if (!_supportedFiles.contains(fileName)) fileName = 'en_US.json';

    // Load package-level translations first (these are the main translations)
    Map<String, dynamic> packageTranslations = {};
    bool packageLoaded = false;

    // Try to load from hk_package first (this has all the translations)
    final packagePaths = [
      'assets/lang/$fileName',
    ];

    for (final packagePath in packagePaths) {
      try {
        final packageContent = await rootBundle.loadString(packagePath);
        packageTranslations = json.decode(packageContent) as Map<String, dynamic>;
        packageLoaded = true;
        break;
      } catch (e) {
        continue;
      }
    }

    if (!packageLoaded) {
      return null;
    }

    // Load app-level translations as overrides (optional)
    Map<String, dynamic> appTranslations = {};
    try {
      final appPath = 'assets/lang/$fileName';
      final appContent = await rootBundle.loadString(appPath);
      appTranslations = json.decode(appContent) as Map<String, dynamic>;
    } catch (e) {
      e.toString();
    }

    // Merge: package translations as base, app overrides on top
    final mergedTranslations = <String, dynamic>{
      ...packageTranslations,  // Base translations from package
      ...appTranslations,      // App-specific overrides
    };

    // Debug: Check if the specific key exists
    if (mergedTranslations.containsKey('hello_member_hindi')) {
    } else {
    }

    return mergedTranslations;
  }
}
