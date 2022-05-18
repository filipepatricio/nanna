import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';

abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> initializeAttribution();

  Future<void> requestTrackingPermission();

  Future<void> login(String userId, String method);

  Future<void> logout();

  void page(AnalyticsPage page);

  void event(AnalyticsEvent event);
}
