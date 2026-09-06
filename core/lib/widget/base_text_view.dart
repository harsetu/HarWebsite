import 'package:core/widget/translatable_text_widget.dart';
import 'package:flutter/material.dart';

import '../utils/formatting_utils.dart';

class BaseTextView extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  final TextAlign? textAlign;
  final List<String>? arg;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isLocalizeText;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final bool? softWrap;
  final bool useAutoTranslation; // New parameter to enable auto translation

  const BaseTextView({
    super.key,
    required this.text,
    this.isLocalizeText = true,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.style,
    this.textAlign,
    this.arg,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.decorationColor,
    this.softWrap = true,
    this.useAutoTranslation = true, // Enable auto translation by default
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle? updatedStyle = style?.copyWith(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      decoration: decoration,
      decorationColor: decorationColor
    );

    final finalStyle = updatedStyle ?? TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );

    // Prepare the display text with arguments if provided
    String displayText = text;
    if (isLocalizeText) {
      displayText = FormattingUtils.getLocalizeString(context, text, arg, isLocalizeText);
    } else if (arg != null && arg!.isNotEmpty) {
      // Simple argument replacement for placeholders like {0}, {1}, etc.
      for (int i = 0; i < arg!.length; i++) {
        displayText = displayText.replaceAll('{$i}', arg![i]);
      }
    }

    // Use the translatable text widget if auto translation is enabled and locale is not English
    if (useAutoTranslation) {
      return TranslatableTextWidget(
        text: displayText,
        style: finalStyle,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign ?? TextAlign.left,
        autoTranslate: true,
        softWrap: softWrap,
      );
    }

    // Fallback to original implementation
    return Text(
      displayText,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.left,
      softWrap: softWrap ?? true,
      style: finalStyle,
    );
  }
}
