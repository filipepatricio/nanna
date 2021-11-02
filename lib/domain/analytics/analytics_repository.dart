abstract class AnalyticsRepository {
  Future<void> login(String userId, String method);

  Future<void> logout();
}
