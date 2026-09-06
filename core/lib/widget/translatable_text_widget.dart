import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/language_bloc.dart';
import '../services/app_translation_service.dart';

class TranslatableTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool autoTranslate;
  final bool? softWrap;

  const TranslatableTextWidget({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.autoTranslate = true,
    this.softWrap,
  });

  @override
  State<TranslatableTextWidget> createState() => _TranslatableTextWidgetState();
}

class _TranslatableTextWidgetState extends State<TranslatableTextWidget> {
  final AppTranslationService _translationService = AppTranslationService();
  String _displayText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _displayText = widget.text;

    // Check current language state when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<LanguageBloc>().state;
      if (currentState is LanguageLoaded && widget.autoTranslate) {
        _translateText(currentState.currentLanguage);
      }
    });
  }

  @override
  void didUpdateWidget(TranslatableTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _displayText = widget.text;
    }
  }

  Future<void> _translateText(String languageCode) async {
    if (!widget.autoTranslate || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final translatedText = await _translationService.translateText(widget.text);

      if (mounted) {
        setState(() {
          _displayText = translatedText;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _displayText = widget.text; // Fallback to original text
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageBloc, LanguageState>(
      listener: (context, state) {
        if (state is LanguageLoaded) {
          _translateText(state.currentLanguage);
        }
      },
      child: _isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _displayText.isEmpty ? widget.text : _displayText,
                    style: widget.style,
                    maxLines: widget.maxLines,
                    overflow: widget.overflow,
                    textAlign: widget.textAlign,
                    softWrap: widget.softWrap,
                  ),
                ),
              ],
            )
          : Text(
              _displayText.isEmpty ? widget.text : _displayText,
              style: widget.style,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              textAlign: widget.textAlign,
              softWrap: widget.softWrap,
            ),
    );
  }
}

