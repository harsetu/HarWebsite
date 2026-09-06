import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'mixpanel_service.dart';

class BaseAnalytics {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final MixpanelService mixpanelService = MixpanelService();

  static Future<void> sendAnalyticsEvent(String key, Map<String, Object> params) async {
    Map<String, Object> commonProperties = await getCommonProperties();
    if (commonProperties.isNotEmpty) {
      params.addAll(commonProperties);
    }
    if (kReleaseMode) {
      mixpanelService.mixpanelInstance.track(
        key,
        properties: params,
      );
    }
    await analytics.logEvent(
      name: key,
      parameters: params,
    );
  }

  //TODO move getCommonProperties from app module
  static Future<Map<String, Object>> getCommonProperties() async {
    /*String? mobileNumber = await SPUtils.getValue<String>(SPConstants.userMobNo);
    if (mobileNumber != null) {
      return {BaseAnalyticsConstants.paramMobileNumber: mobileNumber};
    }
    return {};*/
    return {};
  }
}
