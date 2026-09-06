import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/color_manager.dart';
import '../constants/localization_keys.dart';
import 'base_button.dart';
import 'base_text_view.dart';
import 'no_connection_screen.dart';

class BaseErrorWidget extends StatelessWidget {
  final String? image;
  final String? errorTitle;
  final List<String>? errorArg;
  final String errorMessage;
  final bool btnTryAgain;
  final VoidCallback? callbackTryAgain;

  const BaseErrorWidget({
    super.key,
    this.errorTitle,
    this.errorArg,
    required this.errorMessage,
    this.btnTryAgain = false,
    this.callbackTryAgain,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    if (errorTitle == 'no_internet' || errorMessage == 'no_internet') {
      return NoConnectionScreen(
        onRetry: callbackTryAgain,
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image?.isNotEmpty == true
                ? Padding(padding: EdgeInsets.only(bottom: 16), child: SvgPicture.asset(image!))
                : SizedBox(),
            errorTitle != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BaseTextView(
                      textAlign: TextAlign.center,
                      text: errorTitle!,
                      arg: errorArg,
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: 16,
                        color: ColorManager.colorBlack,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            BaseTextView(
              textAlign: TextAlign.center,
              text: errorMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorManager.colorText70,
              ),
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
