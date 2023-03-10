abstract class AppInfoRepository {
  Future<String> getAppVersion();

  Future<bool> shouldUpdate();

  Future<String?> getLatestAvailableVersion();

  String getPlatform();

  Future<void> openSubscriptionManagementSystemPage(String? sku);
}
