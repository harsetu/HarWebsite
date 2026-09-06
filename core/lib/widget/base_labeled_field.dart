import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// Renders [labelKey] above [child] so a form field has a persistent label
/// rather than relying on hint text alone.
class BaseLabeledField extends StatelessWidget {
  final String labelKey;
  final Widget child;

  /// Optional `{0}`, `{1}`, ... placeholder values for [labelKey], e.g. a
  /// per-item index when the same field repeats in a list.
  final List<String>? arg;

  const BaseLabeledField({
    super.key,
    required this.labelKey,
    required this.child,
    this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseTextView(
          text: labelKey,
          arg: arg,
          style: AppTextStyles.labelRegular,
          textColor: ColorManager.colorText70,
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
