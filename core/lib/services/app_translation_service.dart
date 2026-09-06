import 'package:core/services/translation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../constants/sp_constants.dart';
import '../utils/sp_utility.dart';

class AppTranslationService {
  static final AppTranslationService _instance = AppTranslationService._internal();
  factory AppTranslationService() => _instance;
  AppTranslationService._internal() {
    _loadLanguageCodeFromSP();
  }

  final TranslationService _mlKitTranslationService = TranslationService();

  // Supported languages with their display names.
  static const Map<String, Map<String, String>> supportedLanguages = {
    'hi': {'name': 'Hindi', 'nativeName': 'हिंदी'},
    'en': {'name': 'English', 'nativeName': 'English'},
    'pa': {'name': 'Punjabi', 'nativeName': 'ਪੰਜਾਬੀ'},
  };

  /// Google ML Kit's on-device translator has no Punjabi model, so dynamic
  /// auto-translation isn't available for it — the app relies on the static
  /// `pa_IN.json` easy_localization file for Punjabi UI text instead.
  static const String _unsupportedMlLanguage = 'pa';

  String _currentLanguageCode = 'en';
  bool _isInitialized = false;
  final Map<String, String> _translationCache = {};

  // Callbacks to notify widgets when language changes
  final List<VoidCallback> _languageChangeListeners = [];

  String get currentLanguageCode => _currentLanguageCode;
  String get currentLanguageName => supportedLanguages[_currentLanguageCode]?['name'] ?? 'English';
  String get currentLanguageNativeName => supportedLanguages[_currentLanguageCode]?['nativeName'] ?? 'English';

  /// Initialize the translation service
  Future<bool> initialize() async {
    try {
      await _mlKitTranslationService.initialize();
      _isInitialized = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get TranslateLanguage enum from language code
  TranslateLanguage _getTranslateLanguage(String languageCode) {
    switch (languageCode) {
      case 'en': return TranslateLanguage.english;
      case 'hi': return TranslateLanguage.hindi;
      case 'bn': return TranslateLanguage.bengali;
      case 'gu': return TranslateLanguage.gujarati;
      case 'kn': return TranslateLanguage.kannada;
      case 'mr': return TranslateLanguage.marathi;
      case 'ta': return TranslateLanguage.tamil;
      case 'te': return TranslateLanguage.telugu;
      default: return TranslateLanguage.english;
    }
  }

  /// Remove language change listener
  void removeLanguageChangeListener(VoidCallback listener) {
    _languageChangeListeners.remove(listener);
  }

  /// Translate text to the current selected language
  Future<String> translateText(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Return original text if it's the source language (English), or if ML
    // Kit has no model for the current language (Punjabi) — that text is
    // already resolved via static translations by the time it gets here.
    if (_currentLanguageCode == 'en' || _currentLanguageCode == _unsupportedMlLanguage) {
      return text;
    }

    // Check cache first
    final cacheKey = '${text}_$currentLanguageCode';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    try {
      // Create translator for current language pair
      final targetLanguage = _getTranslateLanguage(_currentLanguageCode);
      final translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: targetLanguage,
      );

      // Check if model is downloaded
      final modelManager = OnDeviceTranslatorModelManager();
      final isModelDownloaded = await modelManager.isModelDownloaded(targetLanguage.bcpCode);

      if (!isModelDownloaded) {
        // Download model if not available
        await modelManager.downloadModel(targetLanguage.bcpCode);
      }

      // Translate the text
      final translatedText = await translator.translateText(text);

      // Cache the result
      _translationCache[cacheKey] = translatedText;

      await translator.close();
      return translatedText;
    } catch (e) {
      return text; // Return original text on error
    }
  }

  /// Change the current language (no EasyLocalization dependency)
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      throw ArgumentError('Unsupported language code: $languageCode');
    }

    _currentLanguageCode = languageCode;

    // Clear translation cache when language changes
    _translationCache.clear();

    // Notify all listeners about language change
    for (final listener in _languageChangeListeners) {
      listener();
    }
  }

  /// Add language change listener
  void addLanguageChangeListener(VoidCallback listener) {
    _languageChangeListeners.add(listener);
  }

  /// Translate multiple texts at once
  Future<Map<String, String>> translateTexts(List<String> texts) async {
    final Map<String, String> results = {};

    for (final text in texts) {
      results[text] = await translateText(text);
    }

    return results;
  }

  /// Get all available languages
  List<Map<String, String>> getAvailableLanguages() {
    return supportedLanguages.entries.map((entry) => {
      'code': entry.key,
      'name': entry.value['name']!,
      'nativeName': entry.value['nativeName']!,
    }).toList();
  }

  /// Check if a language model is downloaded
  Future<bool> isLanguageModelDownloaded(String languageCode) async {
    if (languageCode == 'en' || languageCode == _unsupportedMlLanguage) {
      return true; // No model needed: English is the source, Punjabi has no ML Kit model.
    }

    try {
      final targetLanguage = _getTranslateLanguage(languageCode);
      final modelManager = OnDeviceTranslatorModelManager();
      return await modelManager.isModelDownloaded(targetLanguage.bcpCode);
    } catch (e) {
      return false;
    }
  }

  /// Download language model
  Future<bool> downloadLanguageModel(String languageCode) async {
    if (languageCode == 'en' || languageCode == _unsupportedMlLanguage) {
      return true; // English and Punjabi never need an ML Kit model download.
    }

    try {
      final targetLanguage = _getTranslateLanguage(languageCode);
      final modelManager = OnDeviceTranslatorModelManager();
      await modelManager.downloadModel(targetLanguage.bcpCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear translation cache
  void clearCache() {
    _translationCache.clear();
  }

  /// Dispose of the service
  Future<void> dispose() async {
    await _mlKitTranslationService.dispose();
    _translationCache.clear();
  }

  Future<void> _loadLanguageCodeFromSP() async {
    try {
      final savedCode = await SPUtils.getValue<String>(SPConstants.selectedLanguageCode);
      if (savedCode != null && supportedLanguages.containsKey(savedCode)) {
        _currentLanguageCode = savedCode;
      } else {
        _currentLanguageCode = 'en';
      }
    } catch (e) {
      _currentLanguageCode = 'en';
    }
  }
}
