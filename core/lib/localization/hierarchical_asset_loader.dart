import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Custom asset loader that merges package-level and app-level translations
/// App-level translations take precedence over package-level translations
class HierarchicalAssetLoader extends AssetLoader {
  const HierarchicalAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    // Convert locale to the correct file naming format (e.g., en_US.json)
    final fileName = '${locale.languageCode}_${locale.countryCode}.json';

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
