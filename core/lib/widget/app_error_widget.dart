import 'package:flutter/material.dart';
import '../constants/localization_keys.dart';
import 'base_button.dart';
import 'base_text_view.dart';

class AppErrorWidget extends StatelessWidget {
  final String? errorTitle;
  final List<String>? errorArg;
  final String errorMessage;
  final bool btnTryAgain;
  final VoidCallback? callbackTryAgain;

  const AppErrorWidget(
      {super.key, this.errorTitle, this.errorArg, required this.errorMessage, this.btnTryAgain = false, this.callbackTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            errorTitle != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BaseTextView(
                      text: errorTitle!,
                      arg: errorArg,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            BaseTextView(
              text: errorMessage,
            ),
            const SizedBox(
              height: 16,
            ),
            btnTryAgain
                ? BaseButton(
                    buttonText: LocalizationKeys.tryAgainLabel,
                    onPressed: callbackTryAgain,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
