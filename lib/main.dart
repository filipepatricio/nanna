import 'dart:io';

import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/better_informed_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

const _environmentArgKey = 'env';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = _getEnvironment();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  await configureDependencies(environment);

  setupFimber();

  await Hive.initFlutter();
  final mainRouter = MainRouter();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  final appConfig = getIt.get<AppConfig>();

  await SentryFlutter.init(
    (options) => options
      ..dsn = appConfig.sentryEventDns
      ..environment = environment,
    appRunner: () => runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: availableLocales.values.toList(),
        fallbackLocale: availableLocales[fallbackLanguageCode],
        useOnlyLangCode: true,
        saveLocale: true,
        child: BetterInformedApp(
          mainRouter: mainRouter,
        ),
      ),
    ),
  );
}

void setupFimber() => Fimber.plantTree(getIt());

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
