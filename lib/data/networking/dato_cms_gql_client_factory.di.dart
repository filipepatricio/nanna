import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

const releaseNotesClientName = 'releaseNotes';
const legalPagesClientName = 'legalPages';

@injectable
class DatoCMSGQLClientFactory {
  DatoCMSGQLClientFactory(this._appConfig);

  final AppConfig _appConfig;

  GraphQLClient create(String project) {
    late String token;

    switch (project) {
      case releaseNotesClientName:
        token = 'Bearer ${_appConfig.datoCMSConfig.releaseNotesKey}';
        break;
      case legalPagesClientName:
        token = 'Bearer ${_appConfig.datoCMSConfig.legalPagesKey}';
        break;
    }

    final cache = GraphQLCache(store: InMemoryStore());
    final httpClient = HttpClient()..maxConnectionsPerHost = 1;
    final client = IOClient(httpClient);

    final httpLink = HttpLink(_appConfig.datoCMSConfig.datoCMSUrl, httpClient: client);

    return GraphQLClient(
      cache: cache,
      link: Link.from(
        [
          AuthLink(getToken: () => token),
          httpLink,
        ],
      ),
    );
  }
}
