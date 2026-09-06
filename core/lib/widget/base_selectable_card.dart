import 'package:flutter/material.dart';

import '../constants/color_manager.dart';
import 'base_text_view.dart';

/// A tappable icon+label card used to pick one of a small set of options
/// (e.g. a payment collection method), with a highlighted border/background
/// when [isSelected].
class BaseSelectableCard extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;

  const BaseSelectableCard({
    super.key,
    required this.icon,
    required this.labelKey,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryColor.withAlpha(20)
              : ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? ColorManager.primaryColor
                : ColorManager.colorText20,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? ColorManager.primaryColor
                  : ColorManager.colorText70,
            ),
            const SizedBox(height: 8),
            BaseTextView(
              text: labelKey,
              textAlign: TextAlign.center,
              textColor: isSelected
                  ? ColorManager.primaryColor
                  : ColorManager.colorText70,
            ),
          ],
        ),
      ),
    );
  }
}