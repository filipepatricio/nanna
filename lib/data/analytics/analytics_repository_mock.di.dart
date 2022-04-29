import 'package:better_informed_mobile/domain/analytics/analytics_event.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dt.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_repository.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository, env: mockEnvs)
class AnalyticsRepositoryMock implements AnalyticsRepository {
  @override
  Future<void> initialize() async {
    return;
  }

  @override
  Future<void> login(String userId, String method) async {
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
}
