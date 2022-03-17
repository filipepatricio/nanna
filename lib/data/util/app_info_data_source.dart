import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@lazySingleton
class AppInfoDataSource {
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
}
