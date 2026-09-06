import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utils/formatting_utils.dart';

class BaseTextSpan extends TextSpan {
  final String textString;
  final TextStyle? styleTextSpan;
  final List<String>? arg;
  final BuildContext context;
  final FontWeight? fontWeight;
  final GestureRecognizer? onTapRecognizer;
  final Color? color;
  final bool isLocalizeText;

  BaseTextSpan({
    required this.context,
    required this.textString,
    required this.styleTextSpan,
    this.fontWeight,
    this.arg,
    this.onTapRecognizer,
    this.color,
    this.isLocalizeText = true,
  }) : super(
          text: isLocalizeText ? FormattingUtils.getLocalizeString(context, textString, arg) : textString,
          style: styleTextSpan?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          recognizer: onTapRecognizer,
        );
}
