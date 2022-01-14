import 'package:better_informed_mobile/domain/analytics/analytics_event.dart';
import 'package:better_informed_mobile/domain/analytics/analytics_page.dart';
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
  void track(String name, Map<String, dynamic> properties) {
    return;
  }
}
