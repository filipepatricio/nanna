import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppInfoRepository, env: mockEnvs)
class AppInfoRepositoryMock implements AppInfoRepository {
  @override
  Future<String> getAppVersion() async {
    return '1.0.0';
  }
}
