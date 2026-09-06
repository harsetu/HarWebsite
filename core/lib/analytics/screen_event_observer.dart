import 'package:core/analytics/screen_util.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'mixpanel_service.dart';

const String screenView = 'Screen View';
const String pageName = 'Page Name';

@injectable
class ScreenEventObserver extends NavigatorObserver {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final MixpanelService mixpanelService = MixpanelService();
  ScreenUtil screenUtil;

  ScreenEventObserver(this.screenUtil);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) async {
    Map<String, dynamic> commonProperties = {};
    String screenName = screenUtil.getScreenName(route.settings);

    commonProperties.addAll(Map<String, String>.from({pageName: screenName}));
    if (kReleaseMode) {
      mixpanelService.mixpanelInstance.track(screenView, properties: {pageName: screenName});
    }
    _analytics.logScreenView(screenName: screenName);
  }

  static void onTabClicked(List<String> screensName, int itemSelected) {
    FirebaseAnalytics.instance.logScreenView(screenName: '${screensName[itemSelected]} Screen');
  }
}
