import 'dart:io';

import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.di.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/custom_graphql_client.dart';
import 'package:better_informed_mobile/data/networking/timezone_link/timezone_link.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/io_client.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLGuestClientFactory {
  GraphQLGuestClientFactory(
    this._appConfig,
    this._appVersionLink,
    this._timezoneLink,
    this._generalExceptionMapper,
  );

  final AppConfig _appConfig;
  final AppVersionLink _appVersionLink;
  final TimezoneLink _timezoneLink;
  final CommonExceptionMapper _generalExceptionMapper;

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());
    final httpClient = HttpClient()..maxConnectionsPerHost = 1;
    final client = IOClient(httpClient);

    final httpLink = HttpLink(_appConfig.apiUrl, httpClient: client);
    final link = Link.from(
      [
        _appVersionLink,
        _timezoneLink,
        httpLink,
      ],
    );

    final policies = Policies(
      fetch: FetchPolicy.noCache,
      cacheReread: CacheRereadPolicy.ignoreAll,
    );

    return CustomGraphQlClient(
      link: link,
      cache: cache,
      generalExceptionMapper: _generalExceptionMapper,
      defaultPolicies: DefaultPolicies(
        mutate: policies,
        query: policies,
        subscribe: policies,
        watchMutation: policies,
        watchQuery: policies,
      ),
    );
  }
}
