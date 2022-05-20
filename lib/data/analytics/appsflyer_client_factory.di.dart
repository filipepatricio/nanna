import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppsflyerClientFactory {
  final AppConfig _appConfig;

  AppsflyerClientFactory(
    this._appConfig,
  );

  AppsflyerSdk create() {
    final key = _appConfig.appsFlyerKey;

    if (key == null) throw Exception('Can not initialize attribution repo without appsFlyerKey');

    final apssFlyerOptions = AppsFlyerOptions(
      afDevKey: key,
      appId: _appConfig.appleStoreId,
      showDebug: kDebugMode,
    );
    final sdk = AppsflyerSdk(apssFlyerOptions);

    return sdk;
  }
}
