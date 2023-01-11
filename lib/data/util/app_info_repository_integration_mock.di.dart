import 'package:better_informed_mobile/data/util/app_info_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppInfoRepository, env: integrationTestEnvs)
class AppInfoRepositoryIntegrationMock extends AppInfoRepositoryImpl {
  AppInfoRepositoryIntegrationMock(super.appInfoDataSource);

  @override
  Future<bool> shouldUpdate() async {
    return false;
  }
}
