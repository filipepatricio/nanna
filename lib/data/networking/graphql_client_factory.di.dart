import 'package:better_informed_mobile/data/exception/common_exception_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/app_version_link/app_version_link.di.dart';
import 'package:better_informed_mobile/data/networking/gql_customs/custom_graphql_client.dart';
import 'package:better_informed_mobile/data/networking/timezone_link/timezone_link.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLClientFactory {
  GraphQLClientFactory(
    this._appConfig,
    this._freshLink,
    this._appVersionLink,
    this._timezoneLink,
    this._generalExceptionMapper,
  );

  final AppConfig _appConfig;
  final FreshLink<OAuth2Token> _freshLink;
  final AppVersionLink _appVersionLink;
  final TimezoneLink _timezoneLink;
  final CommonExceptionMapper _generalExceptionMapper;

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());

    final httpLink = HttpLink(_appConfig.apiUrl);
    final link = Link.from(
      [
        _freshLink,
        _appVersionLink,
        _timezoneLink,
        httpLink,
      ],
    );

    return CustomGraphQlClient(
      link: link,
      cache: cache,
      generalExceptionMapper: _generalExceptionMapper,
    );
  }
}
