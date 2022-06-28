import 'dart:async';

import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/data/util/reporting_tree_error_filter.di.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_analytics_use_case.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/informed_app.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:better_informed_mobile/presentation/style/app_theme.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const _environmentArgKey = 'env';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUIOverlayStyleDark);

  final environment = _getEnvironment();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  final getIt = await configureDependencies(environment);

  final appConfig = getIt.get<AppConfig>();
  _setupFimber(getIt);
  await _setupAnalytics(getIt);

  await Hive.initFlutter();
  final mainRouter = MainRouter(mainRouterKey);

  final filterController = getIt<ReportingTreeErrorFilterController>();
  await SentryFlutter.init(
    (options) => options
      ..enableBreadcrumbTrackingForCurrentPlatform()
      ..beforeSend = (event, {hint}) {
        if (filterController.shouldFilterOut(event.throwable)) return null;
        return event;
      }
      ..dsn = (kDebugMode || kProfileMode) ? '' : appConfig.sentryEventDns
      ..tracesSampleRate = 0.2
      ..environment = environment,
    appRunner: () => runApp(
      DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: EasyLocalization(
          path: 'assets/translations',
          supportedLocales: availableLocales.values.toList(),
          fallbackLocale: availableLocales[fallbackLanguageCode],
          useOnlyLangCode: true,
          saveLocale: true,
          child: InformedApp(
            mainRouter: mainRouter,
            getIt: getIt,
          ),
        ),
      ),
    ),
  );
}

void _setupFimber(GetIt getIt) {
  if (kDebugMode) {
    Fimber.plantTree(DebugTree(useColors: true));
  } else {
    Fimber.plantTree(getIt());
  }
}

Future<void> _setupAnalytics(GetIt getIt) => getIt<InitializeAnalyticsUseCase>()();

String _getEnvironment() {
  const env = String.fromEnvironment(_environmentArgKey, defaultValue: Environment.dev);

  switch (env) {
    case 'dev':
      return Environment.dev;
    case 'stage':
      return Environment.test;
    case 'prod':
      return Environment.prod;
    default:
      throw Exception('Unknown environment type: $env');
  }
}
