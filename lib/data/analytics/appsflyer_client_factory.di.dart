import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppsflyerClientFactory {
  AppsflyerClientFactory(
    this._appConfig,
  );
  final AppConfig _appConfig;

  AppsflyerSdk create() {
    final key = _appConfig.appsFlyerKey;

    if (key == null) throw Exception('Can not initialize attribution repo without appsFlyerKey');

    final apssFlyerOptions = AppsFlyerOptions(
      afDevKey: key,
      appId: _appConfig.appleStoreId,
      showDebug: false,
    );
    final sdk = AppsflyerSdk(apssFlyerOptions);

    return sdk;
  }
}
