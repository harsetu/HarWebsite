import 'package:core/di/find_asset.dart';
import 'package:core/models/onboarding_model.dart';
import 'package:flutter/cupertino.dart';

/// Minimal [FindAsset] implementation for the marketing website — the
/// onboarding/splash/carousel assets it describes belong to the mobile
/// app shell and aren't used by any page here, but [AppThemeData] resolves
/// a [FindAsset] from `getIt` unconditionally, so one must be registered.
class WebsiteFindAsset implements FindAsset {
  @override
  bool? isChuckerEnabled = false;

  @override
  AssetImage getLanguageBGImage() => const AssetImage('assets/images/logo.png');

  @override
  String getSplashLogo() => 'assets/images/logo.png';

  @override
  AssetImage getTaglineLogo() => const AssetImage('assets/images/logo.png');

  @override
  String getFont() => 'Poppins';

  @override
  List<String> getCarouselImages() => const [];

  @override
  void setChuckerEnabled(bool isEnabled) => isChuckerEnabled = isEnabled;

  @override
  List<OnboardingModel> getOnboardingData() => const [];
}