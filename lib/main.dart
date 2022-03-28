import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/analytics/use_case/initialize_analytics_use_case.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/informed_app.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final environment = _getEnvironment();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  await configureDependencies(environment);

  final appConfig = getIt.get<AppConfig>();
  _setupFimber();
  await _setupAnalytics();

  await Hive.initFlutter();
  final mainRouter = MainRouter(mainRouterKey);

  await SentryFlutter.init(
    (options) => options
      ..dsn = kDebugMode ? '' : appConfig.sentryEventDns
      ..environment = environment,
    appRunner: () => runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: availableLocales.values.toList(),
        fallbackLocale: availableLocales[fallbackLanguageCode],
        useOnlyLangCode: true,
        saveLocale: true,
        child: InformedApp(mainRouter: mainRouter),
      ),
    ),
  );
}

void _setupFimber() {
  if (kDebugMode) {
    Fimber.plantTree(DebugTree(useColors: true));
  } else {
    Fimber.plantTree(getIt());
  }
}

Future<void> _setupAnalytics() => getIt<InitializeAnalyticsUseCase>()();

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
