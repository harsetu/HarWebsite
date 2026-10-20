import 'package:core/di/find_asset.dart';
import 'package:core/di/service_injection.dart';
import 'package:core/localization/app_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:core/firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/har_setu_app.dart';
import 'services/website_find_asset.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Drops the "/#/" hash from web URLs in favour of clean paths (e.g.
  // /contact instead of /#/contact). Note: this requires the web host to
  // rewrite all paths to index.html (SPA fallback) — without that, a fresh
  // load of a deep link like /contact will 404 on a plain static file host.
  usePathUrlStrategy();
  await EasyLocalization.ensureInitialized();
  await setupService();
  getIt.registerLazySingleton<FindAsset>(() => WebsiteFindAsset());

  // Firebase options are only configured for Android/iOS; skip on web so
  // startup doesn't crash from an UnsupportedError.
  if (!kIsWeb) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {
      // Analytics/crashlytics are best-effort; the site must still load without them.
    }
  }

  runApp(AppLocalization.init(child: const HarSetuApp()));
}
