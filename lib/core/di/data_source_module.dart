import 'package:better_informed_mobile/data/app_link/app_link_data_source.dart';
import 'package:better_informed_mobile/data/app_link/app_link_data_source_impl.dart';
import 'package:injectable/injectable.dart';

@module
abstract class DataSourceModule {
  @preResolve
  Future<AppLinkDataSource> getAppLinkDataSource() => AppLinkDataSourceImpl.create();
}
