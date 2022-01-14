import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';

abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> login(String userId, String method);

  Future<void> logout();

  void page(AnalyticsPage page);

  void event(AnalyticsEvent event);

  void track(String name, Map<String, dynamic> properties);
}
