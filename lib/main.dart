import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/better_informed_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

const _environmentArgKey = 'env';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = _getEnvironment();

  await EasyLocalization.ensureInitialized();
  await configureDependencies(environment);

  setupFimber();

  final mainRouter = MainRouter();

  runApp(
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
