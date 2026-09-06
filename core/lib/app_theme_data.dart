import 'package:flutter/material.dart';

import 'constants/app_text_styles.dart';
import 'constants/color_manager.dart';
import 'di/find_asset.dart';
import 'di/service_injection.dart';

class AppThemeData {
  final FindAsset findAsset = getIt<FindAsset>();

  ThemeData getThemeData(Color color) {
    final textColor = AppThemeColors.lightTheme.textColor;
    final ColorScheme colorSelected = ColorScheme.light(primary: color, primaryContainer: color);
    return ThemeData().copyWith(
      primaryColor: color,
      colorScheme: colorSelected,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
      ),
      textTheme: TextTheme(
        // Maps to Figma H1 (39 / SemiBold)
        displayLarge: AppTextStyles.h1.copyWith(color: textColor),
        // Maps to Figma H2 (31 / SemiBold)
        displayMedium: AppTextStyles.h2.copyWith(color: textColor),
        // Maps to Figma H3 (25 / SemiBold)
        displaySmall: AppTextStyles.h3.copyWith(color: textColor),
        // Maps to Figma Title Semibold (20 / SemiBold)
        headlineLarge: AppTextStyles.titleSemibold.copyWith(color: textColor),
        // Maps to Figma Title Regular (20 / Regular)
        headlineMedium: AppTextStyles.titleRegular.copyWith(color: textColor),
        // Maps to Figma Body Semibold (16 / SemiBold)
        headlineSmall: AppTextStyles.bodySemibold.copyWith(color: textColor),
        // Maps to Figma Body Semibold (16 / SemiBold)
        titleLarge: AppTextStyles.bodySemibold.copyWith(color: textColor),
        // Maps to Figma Label Semibold (14 / SemiBold)
        titleMedium: AppTextStyles.labelSemibold.copyWith(color: textColor),
        // Maps to Figma Label Regular (14 / Regular)
        titleSmall: AppTextStyles.labelRegular.copyWith(color: textColor),
        // Maps to Figma Body Regular (16 / Regular)
        bodyLarge: AppTextStyles.bodyRegular.copyWith(color: textColor),
        // Maps to Figma Label Regular (14 / Regular)
        bodyMedium: AppTextStyles.labelRegular.copyWith(color: textColor),
        // Maps to Figma Body Small Regular (12 / Regular)
        bodySmall: AppTextStyles.bodySmallRegular.copyWith(color: textColor),
        // Maps to Figma Label Semibold (14 / SemiBold)
        labelLarge: AppTextStyles.labelSemibold.copyWith(color: textColor),
        // Maps to Figma Body Small Semibold (12 / SemiBold)
        labelMedium: AppTextStyles.bodySmallSemibold.copyWith(color: textColor),
        // Maps to Figma Validation Regular (10 / Regular)
        labelSmall: AppTextStyles.validationRegular.copyWith(color: textColor),
      ),
    );
  }
}

class AppThemeColors {
// Light Theme 1 (Based on the provided color codes)
  static final lightTheme = _ThemeColors(
    primaryColor: ColorManager.primaryColor,
    primaryColorDark: ColorManager.colorPrimaryDark,
    secondaryColor: ColorManager.secondaryColor,
    hintTextColor: ColorManager.colorHintText,
    errorColor: ColorManager.colorError,
    backgroundColor: ColorManager.colorBackground,
    cardColor: ColorManager.colorWhite,
    textColor: ColorManager.textColor,
    textColorLight: ColorManager.colorTextLight,
    dividerColor: ColorManager.dividerColour,
    shadowColor: ColorManager.colorBlack20,
    bottomBarUnselectedColor: ColorManager.colorBottomBarUnselected,
    borderColor: Colors.transparent,
  );
}

class _ThemeColors {
  final Color primaryColor;
  final Color primaryColorDark;
  final Color secondaryColor;
  final Color hintTextColor;
  final Color errorColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color textColorLight;
  final Color dividerColor;
  final Color shadowColor;
  final Color bottomBarUnselectedColor;
  final Color borderColor;

  const _ThemeColors(
      {required this.primaryColor,
      required this.primaryColorDark,
      required this.secondaryColor,
      required this.hintTextColor,
      required this.errorColor,
      required this.backgroundColor,
      required this.cardColor,
      required this.textColor,
      required this.textColorLight,
      required this.dividerColor,
      required this.shadowColor,
      required this.bottomBarUnselectedColor,
      required this.borderColor});
}
