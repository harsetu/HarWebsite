import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../constants/color_manager.dart';
import '../constants/localization_keys.dart';
import 'base_text_view.dart';

class BoxPinVerification extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hasError;
  final String? errorMessage;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final bool autoValidationEnabled;

  const BoxPinVerification({
    super.key,
    required this.controller,
    required this.focusNode,
    this.length = 6,
    this.hasError = false,
    this.errorMessage,
    this.onCompleted,
    this.onChanged,
    this.autoValidationEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define pinput themes based on Figma design
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: theme.textTheme.titleMedium?.copyWith(
        color: ColorManager.textColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorManager.colorHint, width: 1),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: ColorManager.primaryColor, width: 1),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: ColorManager.primaryColor, width: 1),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      textStyle: defaultPinTheme.textStyle!.copyWith(
        color: ColorManager.colorError,
      ),
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: ColorManager.colorError, width: 1),
      ),
    );

    return Column(
      children: [
        // Pinput OTP input
        Pinput(
          controller: controller,
          focusNode: focusNode,
          length: length,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          forceErrorState: hasError,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onCompleted: onCompleted,
          onChanged: onChanged,
        ),

        // Error message
        if (hasError) ...[
          const SizedBox(height: 12),
          BaseTextView(
            text: errorMessage ?? LocalizationKeys.validationOtpError,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ColorManager.colorError,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
