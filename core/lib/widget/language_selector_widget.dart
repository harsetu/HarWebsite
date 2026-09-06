import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/language_bloc.dart';
import '../constants/color_manager.dart';
import '../constants/sp_constants.dart';
import '../constants/localization_keys.dart';
import '../services/app_translation_service.dart';
import '../utils/sp_utility.dart';
import 'base_text_view.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final Function(String languageCode)? onLanguageChanged;
  final bool showNativeNames;

  const LanguageSelectorWidget({
    super.key,
    this.onLanguageChanged,
    this.showNativeNames = true,
  });

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  final AppTranslationService _translationService = AppTranslationService();

  @override
  void initState() {
    super.initState();
    // Initialize the language bloc
    context.read<LanguageBloc>().add(LanguageInitialized());
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    final savedCode = await SPUtils.getValue<String>(
      SPConstants.selectedLanguageCode,
    );
    if (savedCode != null &&
        savedCode != _translationService.currentLanguageCode && mounted) {
      // Use BLoC to change language
      context.read<LanguageBloc>().add(LanguageChanged(savedCode));
      widget.onLanguageChanged?.call(savedCode);
    }
  }

  Future<void> _changeLanguage(String languageCode, TextTheme textTheme) async {
    try {
      // Check if model is downloaded for non-English languages
      if (languageCode != 'en') {
        final isModelDownloaded = await _translationService
            .isLanguageModelDownloaded(languageCode);

        if (!isModelDownloaded) {
          // Show download dialog
          final shouldDownload = await _showDownloadDialog(
            languageCode,
            textTheme,
          );
          if (!shouldDownload) {
            return;
          }
        }
      }

      // Use BLoC to change language
      if(mounted) {
        context.read<LanguageBloc>().add(LanguageChanged(languageCode));

        // Save selected language code
        await SPUtils.saveValue(SPConstants.selectedLanguageCode, languageCode);

        // Notify parent widget
        widget.onLanguageChanged?.call(languageCode);
      }
    } catch (e) {
      _showErrorSnackBar('Error changing language: $e');
    }
  }

  Future<bool> _showDownloadDialog(
    String languageCode,
    TextTheme textTheme,
  ) async {
    final languageInfo =
        AppTranslationService.supportedLanguages[languageCode]!;
    bool isDownloading = false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // Prevent dismissing during download
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: BaseTextView(
                    text: LocalizationKeys.downloadLanguageModelTitle,
                    useAutoTranslation: false,
                    style: textTheme.titleMedium,
                  ),
                  content: isDownloading
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            BaseTextView(
                              text:
                                  'Downloading ${languageInfo['name']} model...',
                              isLocalizeText: false,
                              useAutoTranslation: false,
                            ),
                          ],
                        )
                      : BaseTextView(
                          text: LocalizationKeys.downloadLanguageModelMessage,
                          arg: [languageInfo['name'] ?? ''],
                          useAutoTranslation: false,
                          style: textTheme.bodyMedium,
                        ),
                  actions: isDownloading
                      ? [] // No actions while downloading
                      : [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: BaseTextView(
                              text: LocalizationKeys.cancelLabel,
                              isLocalizeText: true,
                              useAutoTranslation: false,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isDownloading = true;
                              });
                              try {
                                // Start the download
                                await _translationService.downloadLanguageModel(
                                  languageCode,
                                );

                                // Download completed successfully
                                if(mounted) {
                                  Navigator.of(this.context).pop(true);
                                  _showSuccessSnackBar(
                                    '${languageInfo['name']} model downloaded successfully!',
                                  );
                                }
                              } catch (e) {
                                // Download failed
                                setState(() {
                                  isDownloading = false;
                                });
                                _showErrorSnackBar(
                                  'Failed to download language model: $e',
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: BaseTextView(
                              text: LocalizationKeys.downloadLabel,
                              isLocalizeText: true,
                              useAutoTranslation: false,
                            ),
                          ),
                        ],
                );
              },
            );
          },
        ) ??
        false;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BaseTextView(
          text: message,
          isLocalizeText: false,
          useAutoTranslation: false,
        ),
        backgroundColor: ColorManager.colorError,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BaseTextView(
          text: message,
          isLocalizeText: false,
          useAutoTranslation: false,
        ),
        backgroundColor: ColorManager.card1Border,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languages = _translationService.getAvailableLanguages();
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageLoaded) {
          _showSuccessSnackBar(
            'Language changed to [200m${state.currentLanguageName}[0m',
          );
        } else if (state is LanguageError) {
          _showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        final selectedLanguage = state is LanguageLoaded
            ? state.currentLanguage
            : 'en';
        final isLoading = state is LanguageLoading;
        return _buildListSelector(
          languages,
          selectedLanguage,
          isLoading,
          textTheme,
        );
      },
    );
  }

  Widget _buildListSelector(
    List<Map<String, String>> languages,
    String selectedLanguage,
    bool isLoading,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language['code'] == selectedLanguage;
              final isCurrentlyLoading = isLoading && isSelected;

              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? ColorManager.primaryColor
                        : Colors.grey.shade300,
                    child: BaseTextView(
                      text: language['code']!.toUpperCase(),
                      isLocalizeText: false,
                      useAutoTranslation: false,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? ColorManager.colorWhite
                            : ColorManager.primaryColor,
                      ),
                    ),
                  ),
                  title: BaseTextView(
                    text: language['name']!,
                    isLocalizeText: false,
                    useAutoTranslation: false,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? ColorManager.primaryColor
                          : Colors.black87,
                    ),
                  ),
                  subtitle: widget.showNativeNames
                      ? BaseTextView(
                          text: language['nativeName']!,
                          isLocalizeText: false,
                          useAutoTranslation: false,
                          style: textTheme.bodyMedium,
                        )
                      : null,
                  trailing: isCurrentlyLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: ColorManager.primaryColor,
                        )
                      : Icon(Icons.radio_button_unchecked, color: Colors.grey),
                  onTap: isLoading
                      ? null
                      : () => _changeLanguage(language['code']!, textTheme),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
