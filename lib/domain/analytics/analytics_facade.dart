import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/data/install_attribution_payload.dt.dart';

abstract class AnalyticsFacade {
  Future<void> disable();

  Future<InstallAttributionPayload?> initializeAttribution();

  Future<String?> getAppsflyerId();

  Future<String?> getFbAnonymousId();

  Stream<String> get deepLinkStream;

  Future<void> config(String writeKey);

  Future<void> identify(String userId, [String? method]);

  Future<void> reset();

  void page(AnalyticsPage page);

  Future<void> event(AnalyticsEvent event);
}
