import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';

abstract class AnalyticsFacade {
  Future<void> disable();

  Future<void> initializeAttribution();

  Future<void> config(String writeKey);

  Future<void> identify(String userId, [String? method]);

  Future<void> reset();

  void page(AnalyticsPage page);

  Future<void> event(AnalyticsEvent event);
}
