import 'dart:io';

import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.di.dart';
import 'package:better_informed_mobile/data/networking/auth_graphql_client_factory.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthGraphQLClientFactory, env: liveEnvs)
class AuthGraphQLClientFactoryImpl implements AuthGraphQLClientFactory {
  final AppConfig _config;
  final AppVersionLink _appVersionLink;

  AuthGraphQLClientFactoryImpl(this._config, this._appVersionLink);

  @override
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
