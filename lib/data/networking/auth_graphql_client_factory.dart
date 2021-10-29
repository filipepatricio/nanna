import 'dart:io';

import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGraphQLClientFactory {
  final AppConfig _config;
  final AppVersionLink _appVersionLink;

  AuthGraphQLClientFactory(this._config, this._appVersionLink);

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());
    final httpClient = HttpClient()..maxConnectionsPerHost = 1;
    final client = IOClient(httpClient);

    final httpLink = HttpLink(_config.apiUrl, httpClient: client);

    return GraphQLClient(
      cache: cache,
      link: Link.from(
        [
          _appVersionLink,
          httpLink,
        ],
      ),
    );
  }
}