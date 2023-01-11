import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

@lazySingleton
class AppInfoDataSource {
  AppInfoDataSource() : _upgrader = Upgrader();

  final Upgrader _upgrader;

  Future<String> getAppName() async {
    final platformInfo = await PackageInfo.fromPlatform();
    return platformInfo.appName;
  }

  Future<String> getAppVersion() async {
    final platformInfo = await PackageInfo.fromPlatform();
    return platformInfo.version;
  }

  Future<String> getAppBuildNumber() async {
    final platformInfo = await PackageInfo.fromPlatform();
    return platformInfo.buildNumber;
  }

  Future<String?> latestAvailableVersion() async {
    return _upgrader.currentAppStoreVersion();
  }

  Future<bool> shouldUpdate() async {
    try {
      await _upgrader.initialize();
      return _upgrader.shouldDisplayUpgrade() && _upgrader.belowMinAppVersion();
    } catch (_) {
      return false;
    }
  }
}
