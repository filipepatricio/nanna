import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:better_informed_mobile/domain/analytics/attribution_repository.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AttributionRepository, env: liveEnvs)
class AttributionRepositoryAppsflyer implements AttributionRepository {
  AttributionRepositoryAppsflyer._(this._sdk);

  @factoryMethod
  factory AttributionRepositoryAppsflyer.create(AppConfig config) {
    final key = config.appsFlyerKey;

    if (key == null) throw Exception('Can not initialize attribution repo without appsFlyerKey');

    final apssFlyerOptions = AppsFlyerOptions(
      afDevKey: key,
      appId: config.appleStoreId,
      showDebug: kDebugMode,
    );
    final sdk = AppsflyerSdk(apssFlyerOptions);

    return AttributionRepositoryAppsflyer._(sdk);
  }

  final AppsflyerSdk _sdk;

  @override
  Future<void> initialize() async {
    await _sdk.initSdk();
  }
}
