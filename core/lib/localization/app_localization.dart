import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'hierarchical_asset_loader.dart';

/// App localization helper that manages hierarchical translations
class AppLocalization {

  /// Supported app locales: Hindi (default), English, Punjabi.
  static const List<Locale> supportedLocales = [
    Locale('hi', 'IN'),
    Locale('en', 'US'),
    Locale('pa', 'IN'),
  ];

  /// Initialize EasyLocalization with hierarchical asset loader
  static EasyLocalization init({required Widget child}) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/lang',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: getInitialLocale(),
      saveLocale: true,
      useOnlyLangCode: false,
      // This ensures it looks for en_US.json instead of en.json
      useFallbackTranslations: true,
      // Use fallback if key not found
      assetLoader: const HierarchicalAssetLoader(),
      child: child,
    );
  }

  /// First-launch default locale; once the user picks a language via
  /// `context.setLocale()`, `saveLocale: true` persists and restores that
  /// choice on subsequent launches, overriding this.
  static Locale getInitialLocale() {
    return const Locale('hi', 'IN');
  }

  /// Get localized string by key
  static String getString(String key, {List<String>? args}) {
    if (args != null && args.isNotEmpty) {
      return key.tr(args: args);
    }
    return key.tr();
  }

  /// Get localized string with named arguments
  static String getStringWithNamedArgs(
    String key, {
    Map<String, String>? namedArgs,
  }) {
    if (namedArgs != null && namedArgs.isNotEmpty) {
      return key.tr(namedArgs: namedArgs);
    }
    return key.tr();
  }
}