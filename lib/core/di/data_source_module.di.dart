import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/app_link/app_link_data_source_impl.dart';
import 'package:better_informed_mobile/data/app_link/app_link_data_source_mock.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataSourceModule {
  @dev
  @test
  @prod
  @preResolve
  //Have to manage the AppLinkDataSource setup like this because of its static async factory method
  Future<AppLinkDataSource> getAppLinkDataSource(AppConfig appConfig) => AppLinkDataSourceImpl.create(appConfig);

  @Environment(mockName)
  @preResolve
  Future<AppLinkDataSource> getAppLinkDataSourceMock(AppConfig appConfig) => AppLinkDataSourceMock.create();
}
