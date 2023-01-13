import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository, env: testEnvs)
class AnalyticsRepositoryMock implements AnalyticsRepository {
  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<InstallAttributionPayload?> initializeAttribution() async => null;

  @override
  Future<void> identify(String userId, [String? method]) async {
    return;
  }

  @override
  Future<void> logout() async {
    return;
  }

  @override
  void page(AnalyticsPage page) {
    return;
  }

  @override
  void event(AnalyticsEvent event) {
    return;
  }

  @override
  Future<void> requestTrackingPermission() async {}

  @override
  Future<String?> getAppsflyerId() async => "000-123-012";

  @override
  Future<String?> getFbAnonymousId() async {}
}
