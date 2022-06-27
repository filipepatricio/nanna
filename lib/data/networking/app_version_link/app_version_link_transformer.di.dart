import 'package:better_informed_mobile/data/util/app_info_data_source.di.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

const appVersionHeaderKey = 'X-App-Version';

/// Transforms request by adding [appVersionHeaderKey] to its headers
/// If header map does not exist it will create one
///
/// Header value is app name and app version separated by colon ':'
/// Example: {'X-App-Version': 'informed dev:0.0.1'}
@injectable
class AppVersionLinkTransformer {
  AppVersionLinkTransformer(this._appInfoDataSource);
  final AppInfoDataSource _appInfoDataSource;

  Future<Request> call(Request request) async {
    final appVersionHeaderValue = await _createAppVersionHeaderValue();
    return _transformRequest(request, appVersionHeaderValue);
  }

  Future<String> _createAppVersionHeaderValue() async {
    final appVersion = await _appInfoDataSource.getAppVersion();
    final appName = await _appInfoDataSource.getAppName();

    return '${appName.toLowerCase()}:$appVersion';
  }

  Request _transformRequest(Request request, String appVersionHeaderValue) {
    return request.updateContextEntry<HttpLinkHeaders>(
      (entry) {
        final appVersionHeaderEntry = {
          appVersionHeaderKey: appVersionHeaderValue,
        };

        if (entry == null) {
          return HttpLinkHeaders(
            headers: appVersionHeaderEntry,
          );
        } else {
          entry.headers.addAll(appVersionHeaderEntry);
          return entry;
        }
      },
    );
  }
}
