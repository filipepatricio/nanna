import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:upgrader/upgrader.dart';

@LazySingleton(as: AppInfoRepository, env: mockEnvs)
class AppInfoRepositoryMock implements AppInfoRepository {
  @override
  Future<String> getAppVersion() async {
    return '1.0.0';
  }

  @override
  Future<String?> getLatestAvailableVersion() async {
    return '2.0.0';
  }

  @override
  Future<bool> shouldUpdate() async {
    return Upgrader().shouldDisplayUpgrade();
  }
}
