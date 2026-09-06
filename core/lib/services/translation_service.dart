import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  OnDeviceTranslator? _translator;
  OnDeviceTranslatorModelManager? _modelManager;
  bool _isModelDownloaded = false;

  /// Initialize the translator with English to Hindi language pair
  Future<bool> initialize() async {
    try {
      _modelManager = OnDeviceTranslatorModelManager();

      // Check if the Hindi model is downloaded
      // _isModelDownloaded = await _modelManager!.isModelDownloaded(TranslateLanguage.hindi.bcpCode);

      // if (!_isModelDownloaded) {
        // Download the model if not available
        // await _downloadModel();
      // }

      // Create translator after ensuring model is available
      _translator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: TranslateLanguage.english,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Download the translation model
  Future<bool> _downloadModel() async {
    try {
      _modelManager ??= OnDeviceTranslatorModelManager();

      // Download Hindi model
      await _modelManager!.downloadModel(TranslateLanguage.hindi.bcpCode);
      _isModelDownloaded = true;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if the translation model is downloaded
  Future<bool> isModelAvailable() async {
    try {
      _modelManager ??= OnDeviceTranslatorModelManager();
      return await _modelManager!.isModelDownloaded(TranslateLanguage.hindi.bcpCode);
    } catch (e) {
      return false;
    }
  }

  /// Translate text from English to Hindi
  Future<String> translateToHindi(String englishText) async {
    try {
      if (_translator == null) {
        final initialized = await initialize();
        if (!initialized) {
          return englishText; // Return original text if initialization fails
        }
      }

      if (!_isModelDownloaded) {
        final downloaded = await _downloadModel();
        if (!downloaded) {
          return englishText; // Return original text if model download fails
        }
      }

      final translatedText = await _translator!.translateText(englishText);
      return translatedText;
    } catch (e) {
      return englishText; // Return original text on error
    }
  }

  /// Translate text from Hindi to English
  Future<String> translateToEnglish(String hindiText) async {
    try {
      // Create a reverse translator for Hindi to English
      final reverseTranslator = OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.hindi,
        targetLanguage: TranslateLanguage.english,
      );

      final translatedText = await reverseTranslator.translateText(hindiText);
      await reverseTranslator.close();

      return translatedText;
    } catch (e) {
      return hindiText; // Return original text on error
    }
  }

  /// Get available languages
  List<TranslateLanguage> getAvailableLanguages() {
    return TranslateLanguage.values;
  }

  /// Check if a specific language model is downloaded
  Future<bool> isLanguageModelDownloaded(TranslateLanguage language) async {
    try {
      _modelManager ??= OnDeviceTranslatorModelManager();
      return await _modelManager!.isModelDownloaded(language.bcpCode);
    } catch (e) {
      return false;
    }
  }

  /// Download a specific language model
  Future<bool> downloadLanguageModel(TranslateLanguage language) async {
    try {
      _modelManager ??= OnDeviceTranslatorModelManager();
      await _modelManager!.downloadModel(language.bcpCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a specific language model to free up space
  Future<bool> deleteLanguageModel(TranslateLanguage language) async {
    try {
      _modelManager ??= OnDeviceTranslatorModelManager();
      await _modelManager!.deleteModel(language.bcpCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Dispose of the translator
  Future<void> dispose() async {
    await _translator?.close();
    _translator = null;
    _modelManager = null;
  }
}
