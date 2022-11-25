import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';

abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<InstallAttributionPayload?> initializeAttribution();

  Future<String?> getAppsflyerId();

  Future<String?> getFbAnonymousId();

  Future<void> requestTrackingPermission();

  Future<void> identify(String userId, [String? method]);

  Future<void> logout();

  void page(AnalyticsPage page);

  void event(AnalyticsEvent event);
}
