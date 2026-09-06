import 'package:core/app_theme_data.dart';
import 'package:core/bloc/language_bloc.dart';
import 'package:core/constants/color_manager.dart';
import 'package:core/di/service_injection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routing/app_router.dart';

class HarSetuApp extends StatelessWidget {
  const HarSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BaseTextView/BaseButton read LanguageBloc for their translation
    // behaviour regardless of feature flags, so it must be available
    // app-wide even though this site never triggers translation.
    return BlocProvider<LanguageBloc>.value(
      value: getIt<LanguageBloc>(),
      child: MaterialApp.router(
        title: 'HarSetu Tech',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData().getThemeData(ColorManager.primaryColor),
        routerConfig: appRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
