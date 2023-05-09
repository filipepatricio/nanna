import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository, env: liveEnvs)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._config, this._analyticsFacade);
  final AppConfig _config;
  final AnalyticsFacade _analyticsFacade;

  @override
  Future<void> initialize() async {
    final writeKey = _config.segmentWriteKey;

    if (writeKey == null || !kReleaseMode) {
      return _analyticsFacade.disable();
    }

    await _analyticsFacade.config(writeKey);
  }

  /// Deferred initialization of Appsflyer for its dependency on device's IDFA (we need to request permission first)
  @override
  Future<InstallAttributionPayload?> initializeAttribution() async {
    return _analyticsFacade.initializeAttribution();
  }

  @override
  Future<String?> getAppsflyerId() => _analyticsFacade.getAppsflyerId();

  @override
  Future<String?> getFbAnonymousId() => _analyticsFacade.getFbAnonymousId();

  @override
  Future<void> identify(String userId, [String? method]) async {
    await _analyticsFacade.identify(userId, method);
  }

  @override
  Future<void> logout() async {
    await _analyticsFacade.event(AnalyticsEvent.logout());
    await _analyticsFacade.reset();
  }

  @override
  void page(AnalyticsPage page) {
    _analyticsFacade.page(page);
  }

  @override
  void event(AnalyticsEvent event) {
    _analyticsFacade.event(event);
  }
}
