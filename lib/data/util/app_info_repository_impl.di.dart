import 'package:better_informed_mobile/data/util/app_info_data_source.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/app_info_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppInfoRepository, env: liveEnvs)
class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(this._appInfoDataSource);

  final AppInfoDataSource _appInfoDataSource;

  @override
  Future<String> getAppVersion() async {
    return _appInfoDataSource.getAppVersion();
  }

  @override
  Future<String?> getLatestAvailableVersion() {
    return _appInfoDataSource.latestAvailableVersion();
  }

  @override
  Future<bool> shouldUpdate() {
    return _appInfoDataSource.shouldUpdate();
  }

  @override
  String getPlatform() {
    return defaultTargetPlatform.name.toLowerCase();
  }
}
