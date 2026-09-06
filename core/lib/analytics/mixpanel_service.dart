import 'package:flutter/foundation.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  static final MixpanelService _singleton = MixpanelService._internal();

  factory MixpanelService() {
    return _singleton;
  }

  MixpanelService._internal();

  late Mixpanel _mixpanel;

  Mixpanel get mixpanelInstance => _mixpanel;

  // TODO get mixpanel key from app module EnvConstants.mixpanelConstant
  Future<void> initializeMixpanel(String key) async {
    if (kReleaseMode) {
      _mixpanel = await Mixpanel.init("EnvConstants.mixpanelConstant", trackAutomaticEvents: true);
    }
  }
}
