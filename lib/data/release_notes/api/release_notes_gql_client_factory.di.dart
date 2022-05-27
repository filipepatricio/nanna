import 'dart:io';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReleaseNotesGQLClientFactory {
  ReleaseNotesGQLClientFactory(this._appConfig);

  final AppConfig _appConfig;

  GraphQLClient create() {
    final token = 'Bearer ${_appConfig.datoCMSKey}';

    final cache = GraphQLCache(store: InMemoryStore());
    final httpClient = HttpClient()..maxConnectionsPerHost = 1;
    final client = IOClient(httpClient);

    final httpLink = HttpLink('https://graphql.datocms.com', httpClient: client);

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
