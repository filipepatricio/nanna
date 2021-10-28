import 'package:better_informed_mobile/domain/analytics/analytics_login_event.dart';

abstract class AnalyticsRepository {
  Future<void> login(String userId, String method);

  Future<void> logout();
}
