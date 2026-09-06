import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../services/app_translation_service.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LanguageInitialized extends LanguageEvent {}

// States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {
  final String currentLanguage;

  const LanguageLoading(this.currentLanguage);

  @override
  List<Object> get props => [currentLanguage];
}

class LanguageLoaded extends LanguageState {
  final String currentLanguage;
  final String currentLanguageName;
  final bool isModelDownloaded;

  const LanguageLoaded({
    required this.currentLanguage,
    required this.currentLanguageName,
    required this.isModelDownloaded,
  });

  @override
  List<Object> get props => [currentLanguage, currentLanguageName, isModelDownloaded];
}

class LanguageError extends LanguageState {
  final String message;
  final String currentLanguage;

  const LanguageError({
    required this.message,
    required this.currentLanguage,
  });

  @override
  List<Object> get props => [message, currentLanguage];
}

// BLoC
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final AppTranslationService _translationService;

  LanguageBloc({AppTranslationService? translationService})
      : _translationService = translationService ?? AppTranslationService(),
        super(LanguageInitial()) {
    on<LanguageInitialized>(_onLanguageInitialized);
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLanguageInitialized(
    LanguageInitialized event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      final currentLanguage = _translationService.currentLanguageCode;
      final currentLanguageName = _translationService.currentLanguageName;
      final isModelDownloaded = await _translationService.isLanguageModelDownloaded(currentLanguage);

      emit(LanguageLoaded(
        currentLanguage: currentLanguage,
        currentLanguageName: currentLanguageName,
        isModelDownloaded: isModelDownloaded,
      ));
    } catch (e) {
      emit(LanguageError(
        message: 'Failed to initialize language: $e',
        currentLanguage: 'en',
      ));
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    final currentState = state;
    if (currentState is LanguageLoaded) {
      emit(LanguageLoading(currentState.currentLanguage));
    }

    try {
      // Check if model is downloaded for non-English languages
      if (event.languageCode != 'en') {
        final isModelDownloaded = await _translationService.isLanguageModelDownloaded(event.languageCode);

        if (!isModelDownloaded) {
          // Download the model
          final downloadSuccess = await _translationService.downloadLanguageModel(event.languageCode);
          if (!downloadSuccess) {
            emit(LanguageError(
              message: 'Failed to download language model for ${event.languageCode}',
              currentLanguage: _translationService.currentLanguageCode,
            ));
            return;
          }
        }
      }

      // Change language
      await _translationService.changeLanguage(event.languageCode);

      final newLanguageName = _translationService.currentLanguageName;
      final isModelDownloaded = await _translationService.isLanguageModelDownloaded(event.languageCode);

      emit(LanguageLoaded(
        currentLanguage: event.languageCode,
        currentLanguageName: newLanguageName,
        isModelDownloaded: isModelDownloaded,
      ));
    } catch (e) {
      emit(LanguageError(
        message: 'Failed to change language: $e',
        currentLanguage: _translationService.currentLanguageCode,
      ));
    }
  }
}
