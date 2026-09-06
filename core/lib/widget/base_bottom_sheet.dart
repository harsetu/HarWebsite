import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../constants/color_manager.dart';
import 'base_button.dart';
import 'base_text_view.dart';

/// Shows a bottom sheet with an icon, a message, and a single action button —
/// the shared shape behind the confirmation/error sheets used across feature
/// screens (e.g. "no trust property configured, contact trust admin").
Future<void> showBaseMessageBottomSheet(
  BuildContext context, {
  required String message,
  required String buttonLabel,
  IconData icon = Icons.error_outline,
  Color? iconColor,
  VoidCallback? onPressed,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor ?? ColorManager.colorError, size: 48),
            const SizedBox(height: 16),
            BaseTextView(text: message, style: AppTextStyles.h3, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: BaseButton(
                buttonText: buttonLabel,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onPressed?.call();
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
