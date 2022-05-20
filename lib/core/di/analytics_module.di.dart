import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:better_informed_mobile/data/analytics/appsflyer_client_factory.di.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AnalyticsModule {
  @lazySingleton
  AppsflyerSdk createAppsflyerClient(AppsflyerClientFactory factory) => factory.create();
}
