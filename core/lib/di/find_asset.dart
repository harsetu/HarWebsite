import 'package:flutter/cupertino.dart';

import '../models/onboarding_model.dart';

abstract class FindAsset {
  bool? isChuckerEnabled;
  AssetImage getLanguageBGImage();

  String getSplashLogo();

  AssetImage getTaglineLogo();

  String getFont();

  List<String> getCarouselImages();

  void setChuckerEnabled(bool isEnabled);

  List<OnboardingModel> getOnboardingData();
}
