import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_facade.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsFacade, env: mockEnvs)
class AnalyticsFacadeMock implements AnalyticsFacade {
  AnalyticsFacadeMock();

  final _deepLinkStream = StreamController<String>.broadcast();

  @override
  Future<InstallAttributionPayload?> initializeAttribution() async {
    return null;
  }

  @override
  void subscribeToAppsflyerDeepLink() {}

  @override
  Stream<String> get deepLinkStream => _deepLinkStream.stream;

  @override
  Future<String?> getAppsflyerId() async => null;

  @override
  Future<void> config(String writeKey) async {}

  @override
  Future<void> identify(String userId, [String? method]) async {}

  @override
  void page(AnalyticsPage page) {}

  @override
  Future<void> event(AnalyticsEvent event) async {}

  @override
  Future<void> reset() async {
    await _deepLinkStream.close();
  }

  @override
  Future<void> disable() async {}
}
