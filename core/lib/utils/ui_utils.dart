import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/color_manager.dart';
import '../constants/localization_keys.dart';
import '../widget/base_button.dart';
import '../widget/base_text_view.dart';

class UiUtils {
  static void showLoadingDialog(
    BuildContext context, {
    bool isDismissible = false,
    String loadingMessage = LocalizationKeys.loadingLabel,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.0),
            BaseTextView(text: loadingMessage),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: isDismissible,
      context: context,
      builder: (BuildContext context) {
        return PopScope(canPop: false, child: alert);
      },
    );
  }

  static void showCustomDialog(
    BuildContext context,
    Widget dialogContainer, [
    bool? barrierDissmiss,
  ]) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: dialogContainer,
    );
    showDialog(
      barrierDismissible: barrierDissmiss ?? true,
      context: context,
      builder: (BuildContext context) {
        return PopScope(canPop: true, child: alert);
      },
    );
  }

  static void showBottomDialog(
      ThemeData themeData,
      BuildContext context,
      String image,
      String popupTitle,
      String popupMessage,
      String positiveBtn,
      String? negativeBtn,
      Function() positiveBtnCallBack,
      Function()? negativeBtnCallBack,
      ) async {
    await showModalBottomSheet(
      isDismissible: false,
      enableDrag:false,
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        image,
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      BaseTextView(
                        text: popupTitle,
                        style: themeData.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: BaseTextView(
                      text: popupMessage,
                      style: themeData.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: negativeBtn != null,
                        child: Expanded(
                          child: BaseButton(
                            buttonText: negativeBtn ?? '',
                            onPressed: negativeBtnCallBack,
                            buttonTypeEnum: BaseButtonTypeEnum.buttonTypeOutline,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: negativeBtn != null,
                        child: const SizedBox(
                          width: 16,
                        ),
                      ),
                      Expanded(
                        child: BaseButton(
                          buttonText: positiveBtn,
                          onPressed: positiveBtnCallBack,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getDialogWithTitleMessage(
    BuildContext context,
    String? imgPath,
    String? textTitle,
    String? textMessage, {
    List<String>? arg,
    List<String>? argMessage,
    String? positiveButton,
    VoidCallback? onPressed,
    String? negativeButton,
    VoidCallback? onPressedNegative,
  }) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imgPath != null
              ? SvgPicture.asset(imgPath, width: 48, height: 48)
              : const SizedBox(),
          textTitle != null
              ? SizedBox(height: imgPath == null ? 12 : 24)
              : const SizedBox(),
          textTitle != null
              ? BaseTextView(
                  text: textTitle,
                  arg: arg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SizedBox(),
          textMessage != null ? const SizedBox(height: 24) : const SizedBox(),
          textMessage != null
              ? BaseTextView(
                  text: textMessage,
                  arg: argMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.colorHintText,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : const SizedBox(),
          positiveButton != null
              ? const SizedBox(height: 32)
              : const SizedBox(),
          (positiveButton != null && onPressed != null)
              ? (negativeButton != null && onPressedNegative != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BaseButton(
                              buttonText: negativeButton,
                              onPressed: onPressedNegative,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: BaseButton(
                              buttonText: positiveButton,
                              onPressed: onPressed,
                            ),
                          ),
                        ],
                      )
                    : BaseButton(
                        buttonText: positiveButton,
                        onPressed: onPressed,
                      )
              : const SizedBox(),
        ],
      ),
    );
  }

  static void dismissProgressDialogue(BuildContext context) {
    Navigator.of(context).pop();
  }
}
