import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// A tappable, pill-shaped chip used for single-choice filters (e.g. a
/// horizontal row of date filters), with a filled style when [isSelected].
class BaseChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLocalizeText;

  const BaseChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isLocalizeText = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.primaryColor : ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ColorManager.primaryColor : ColorManager.colorBorder,
          ),
        ),
        child: BaseTextView(
          text: label,
          isLocalizeText: isLocalizeText,
          useAutoTranslation: isLocalizeText,
          style: AppTextStyles.labelSemibold,
          textColor: isSelected ? ColorManager.colorWhite : ColorManager.colorText70,
        ),
      ),
    );
  }
}