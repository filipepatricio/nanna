abstract class AnalyticsRepository {
  Future<void> initialize();

  Future<void> login(String userId, String method);

  Future<void> logout();
}
