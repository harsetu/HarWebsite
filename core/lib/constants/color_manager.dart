import 'package:flutter/material.dart';

import '../models/config.dart';

class ColorManager {
  static Color get primaryColor {
    if (Config.hasThemeConfig) {
      return Config.themeConfig.primary;
    }
    return const Color(0xffB97912); // Default primary color (Burnt Gold — trust management theme)
  }

  static Color get secondaryColor {
    if (Config.hasThemeConfig) {
      return Config.themeConfig.secondary;
    }
    return const Color(0xffB97912); // Default secondary color (matches primary as per theme_config)
  }

  static Color get colorErrorColor {
    if (Config.hasThemeConfig) {
      return Config.themeConfig.error;
    }
    return const Color(0xffFF4F4F); // Default error color
  }

  static Color get colorSuccessColor {
    if (Config.hasThemeConfig) {
      return Config.themeConfig.success;
    }
    return const Color(0xff030450); // Default success color
  }

  static const Color colorPrimaryDark = Color(0xFF3E1E0A);
  static const Color primaryCream = Color(0xffF7F7F7);

  static Color get secondaryColor12 {
    if (Config.hasThemeConfig) {
      return Config.themeConfig.secondary.withValues(alpha: 0.12);
    }
    return const Color(0x1F0C73B9); // Default secondary color with alpha
  }

  static const Color colorBlack = Color(0xFF000000);
  static const Color colorHintText = Color(0xff9CA3AF);
  static const Color colorTextLight = Color(0xff525866);
  static const Color colorWhite = Color(0xffffffff);
  static const Color colorGrey = Color(0xffF5F5F5);
  static const Color colorBackground = Color(0xffF9FAFB);
  static const Color colorBlack20 = Color(0x33000000);
  static const Color colorBottomBarUnselected = Color(0xff9B9D9E);
  static const Color dividerColour = Color(0xffE5E7EB);
  static const Color textColor = Color(0xff202020);
  static const Color colorText10 = Color(0x1A202020);
  static const Color colorText20 = Color(0x33202020);
  static const Color colorText50 = Color(0x80202020);
  static const Color colorText70 = Color(0xB2202020);
  static const Color colorText80 = Color(0xCC202020);
  static const Color colorText90 = Color(0xE5202020);
  static const Color colorError = Color(0xffD23A3B);
  static const Color colorBorder = Color(0xffCBD5E1);
  static const Color colorHint = Color(0xff94A2B8);
  static const Color primaryMercury50 = Color(0xFFF8F5F4);
  static const Color primaryMercury100 = Color(0xffEDE7E3);
  static const Color adminBase = Color(0xffB84323);
  static const Color upkeepBase = Color(0xff18A30B);
  static const Color kycBase = Color(0xff0B8984);
  static const Color lndBase = Color(0xff6F30DB);
  static const Color sdBase = Color(0xff1165BE);
  static const Color ccBase = Color(0xff2B1BA9);
  static const Color fnbBase = Color(0xffFD951C);
  static const Color rewardsBase = Color(0xffFB3B9A);
  static const Color secondarySlate100 = Color(0xffF1F5F9);
  static const Color primaryIconColor = Color(0xff475569);
  static const Color disabledCardBackground = Color(0xFFE1E1E4);
  static const Color disabledImageColor = Color(0xFFE2E8F0);
  static const Color comingSoonGradientEnd = Color(0xFFA07B6F);
  static const Color adminGradientColor = Color(0xFFF6ECE9);
  static const Color adminBorderColor = Color(0xFFECD0C8);
  static const Color adminImageBgColor = Color(0xFFF0DCD6);
  static const Color tasksGradientColor = Color(0xFFEAF0E5);
  static const Color tasksBorderColor = Color(0xFFC0D6B9);
  static const Color tasksImageBgColor = Color(0xFFCFE7C9);
  static const Color kycGradientColor = Color(0xFFE9EFED);
  static const Color kycBorderColor = Color(0xFFC1DBDA);
  static const Color kycImageBgColor = Color(0xFFCCE1E0);
  static const Color lndGradientColor = Color(0xFFEEE6F3);
  static const Color lndBorderColor = Color(0xFFD9C9F0);
  static const Color lndImageBgColor = Color(0xFFE2D5F2);
  static const Color sdGradientColor = Color(0xFFE9ECF1);
  static const Color sdBorderColor = Color(0xFFC2D4E8);
  static const Color sdImageBgColor = Color(0xFFCEDBEB);
  static const Color ccGradientColor = Color(0xFFEBE8F0);
  static const Color ccBorderColor = Color(0xFFC9C3E3);
  static const Color ccImageBgColor = Color(0xFFD3CEE8);
  static const Color fnbGradientColor = Color(0xFFF9EFE6);
  static const Color fnbBorderColor = Color(0xFFFADFC2);
  static const Color fnbImageBgColor = Color(0xFFFAE4CD);
  static const Color rewardsGradientColor = Color(0xFFF9E9EF);
  static const Color rewardsBorderColor = Color(0xFFF9CAE0);
  static const Color rewardsImageBgColor = Color(0xFFF9D4E5);
  static const Color profileGradientStart = Color(0xFFB11965);
  static const Color profileGradientEnd = Color(0xFF982791);
  static const Color colorRed500 = Color(0xFFFF114C);
  static const Color colorRed50 = Color(0XFFFFEEF2);
  static const Color card1Border = Color(0xFF6AEBBC);
  static const Color shadow1 = Color(0xFF000000);
  static const Color card1 = Color(0xFFEBFEF6);
  static const Color card2Border = Color(0xFFF0CE54);
  static const Color card2 = Color(0xFFFCFAEA);
  static const Color card3Border = Color(0xFF72A5E8);
  static const Color shadow = Color(0xF0000000);
  static const Color card3 = Color(0xFFEBF2FC);
  static const Color buttonBorderColor = Color(0xFFF8ECE9);
  static const Color buttonBaseColor = Color(0xFFD0FBE6);
  static const Color colorBlack60 = Color(0x99000000);

  static const Color taskSwitchColor = Color(0xffECEEF4);
  static const Color supportingRed800 = Color(0xFFBE002F);
  static const Color supportingRed600 = Color(0xFFFF0040);

  static const Color lightPinkSelectedColor = Color(0xFFFCE4EC); // Colors.pink.shade50
  static const Color darkPinkIconTextColor = Color(0xFFC2185B);
  static const Color radialGradientEnd = Color(0x3BFFFFFF);

  static const Color supportingRed300 = Color(0XFFFF8BA8);
  static const Color supportingRed200 = Color(0XFFFFBBCC);
  static const Color supportingRed100 = Color(0XFFFFDAE3);
  static const Color supportingRed50 = Color(0XFFFFEEF2);
  static const Color supportingRedLeave = Color(0xFFFFCCD9);
  static const Color supportingSuccess700 = Color(0xFF008060);
  static const Color supportingSuccess600 = Color(0XFF009B70);
  static const Color supportingSuccess500 = Color(0xFF0ABF89);
  static const Color supportingSuccess200 = Color(0XFFA4F6D3);
  static const Color supportingSuccess100 = Color(0XFFBBF8DE);
  static const Color supportingWarning600 = Color(0xFFB97912);
  static const Color supportingWarning400 = Color(0xFFEAB625);
  static const Color supportingWarning200 = Color(0xFFF6E492);
  static const Color supportingWarning100 = Color(0xFFF7E7A0);
  static const Color supportingBlue400 = Color(0xFF4B8DE0);
  static const Color supportingBlue200 = Color(0xFF99BDF1);
  static const Color supportingBlue100 = Color(0xFFB3CDF5);
  static const Color secondarySlate50 = Color(0XFFF8FAFC);
  static const Color colorText30 = Color(0x4D202020);
  static const Color colorText60 = Color(0x99202020);
  static const Color backgroundGrey = Color(0x0D202020);
  static const Color daysPillBackground = Color(0xFFFAF2C7);
  static const Color colorPeachNav = Color(0xFFEBD4CE);
  static const Color colorGreenNav = Color(0xFFEBFEF6);
  static const Color adminCustom = Color(0xFFE6BDB2);
  static const Color whiteCustom = Color(0x00FFFFFF);
  static const Color customFnb = Color(0xFFFEECDA);
  static const Color text90 = Color(0xE5202020);
  static const Color leaveButtonColor = Color(0xFFFFD7E1);
  static const Color customFnb200 = Color(0xFFFDD2A4);
  static  const Color primaryColor1 = Color(0xFF800020);
  static const Color successColor = Color(0xFF03624A);
  static const Color pendingColor = Color(0xFF6A3A19);

  /// Gradient background colors
  static const Color gradientTopBottomColor = Color(0xFFE7003A);
  static const Color gradientMiddleColor = Color(0x99E7003A); // #E7003A99 with 60% opacity

  /// Screen background (auth screens)
  static const Color colorScreenBackground = Color(0xFFFBFAF9);
  /// Disabled button background
  static const Color colorButtonDisabled = Color(0xFFCFCED3);

  // ── Figma Design Tokens ────────────────────────────────────────────────────

  // Dawn Pink
  static const Color dawnPink20   = Color(0xFFFBFAF9);
  static const Color dawnPink50   = Color(0xFFF8F5F4);
  static const Color dawnPink100  = Color(0xFFEDE7E3);
  static const Color dawnPink200  = Color(0xFFDDD2CB);
  static const Color dawnPink300  = Color(0xFFC7B4AA);
  static const Color dawnPink400  = Color(0xFFB09287);
  static const Color dawnPink500  = Color(0xFFA07B6F);
  static const Color dawnPink600  = Color(0xFF936B63);
  static const Color dawnPink700  = Color(0xFF7B5853);
  static const Color dawnPink800  = Color(0xFF654A47);
  static const Color dawnPink950  = Color(0xFF2C1F1E);

  // Gondola
  static const Color gondola950   = Color(0xFF1B0107);

  // French Gray
  static const Color frenchGray50  = Color(0xFFF6F6F7);
  static const Color frenchGray100 = Color(0xFFEFEFF0);
  static const Color frenchGray200 = Color(0xFFE1E1E4);
  static const Color frenchGray300 = Color(0xFFCFCED3);
  static const Color frenchGray400 = Color(0xFFC0BEC4);
  static const Color frenchGray500 = Color(0xFFA9A6AE);
  static const Color frenchGray600 = Color(0xFF96919A);
  static const Color frenchGray700 = Color(0xFF817D85);
  static const Color frenchGray800 = Color(0xFF6A666D);
  static const Color frenchGray900 = Color(0xFF57555A);
  static const Color frenchGray950 = Color(0xFF333234);

  // Monarch (brand red)
  static const Color monarch50  = Color(0xFFFFEEF2);
  static const Color monarch100 = Color(0xFFFFDAE3);
  static const Color monarch200 = Color(0xFFFFBBCC);
  static const Color monarch300 = Color(0xFFFF8BA8);
  static const Color monarch400 = Color(0xFFFF4976);
  static const Color monarch500 = Color(0xFFFF114C);
  static const Color monarch600 = Color(0xFFFF0040);
  static const Color monarch700 = Color(0xFFE7003A);
  static const Color monarch800 = Color(0xFFBE002F);
  static const Color monarch900 = Color(0xFF800020);
  static const Color monarch950 = Color(0xFF560015);

  // Pirate Gold (amber/warning)
  static const Color pirateGold50  = Color(0xFFFCFAEA);
  static const Color pirateGold100 = Color(0xFFFAF2C7);
  static const Color pirateGold200 = Color(0xFFF6E492);
  static const Color pirateGold300 = Color(0xFFF0CE54);
  static const Color pirateGold400 = Color(0xFFEAB625);
  static const Color pirateGold500 = Color(0xFFDA9F18);
  static const Color pirateGold600 = Color(0xFFB97912);
  static const Color pirateGold700 = Color(0xFF965812);
  static const Color pirateGold800 = Color(0xFF7C4617);
  static const Color pirateGold900 = Color(0xFF6A3A19);
  static const Color pirateGold950 = Color(0xFF3E1E0A);

  // Deep Sea (success green)
  static const Color deepSea20  = Color(0xFFF5FFFB);
  static const Color deepSea50  = Color(0xFFEBFEF6);
  static const Color deepSea100 = Color(0xFFD0FBE6);
  static const Color deepSea200 = Color(0xFFA4F6D3);
  static const Color deepSea300 = Color(0xFF6AEBBC);
  static const Color deepSea400 = Color(0xFF2FD8A0);
  static const Color deepSea500 = Color(0xFF0ABF89);
  static const Color deepSea600 = Color(0xFF009B70);
  static const Color deepSea700 = Color(0xFF008060);
  static const Color deepSea800 = Color(0xFF03624A);
  static const Color deepSea900 = Color(0xFF04503F);
  static const Color deepSea950 = Color(0xFF012D25);

  // Shark (neutral dark)
  static const Color shark100 = Color(0xFFE4E8E9);
  static const Color shark200 = Color(0xFFCBD2D6);
  static const Color shark600 = Color(0xFF535D67);
  static const Color shark700 = Color(0xFF474E57);
  static const Color shark950 = Color(0xFF222529);

  // Manhattan (accent orange)
  static const Color manhattan300 = Color(0xFFEFBF8E);
  static const Color manhattan400 = Color(0xFFE59352);

  // Prive (dark neutral)
  static const Color prive200 = Color(0xFF1A1A1A);
  static const Color prive300 = Color(0xFF262626);

  // Alert
  static const Color alertRed = Color(0xFFF04438);

  // ── End Figma Design Tokens ────────────────────────────────────────────────

  /// Create gradient background with top/bottom #FF800020 and middle #E7003A99 centered
  static RadialGradient get backgroundGradient {
    return RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: const [
        Color(0xFFE7003A),   // center
        Color(0x99E7003A),   // edge with opacity
      ],
      stops: const [0.0, 1.0],
      transform: GradientRotation(0),
    );
  }

}
