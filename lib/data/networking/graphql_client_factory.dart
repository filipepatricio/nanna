import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLClientFactory {
  final AppConfig _appConfig;
  final FreshLink<OAuth2Token> _freshLink;

  GraphQLClientFactory(
    this._appConfig,
    this._freshLink,
  );

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());

    final httpLink = HttpLink(_appConfig.apiUrl);
    final link = Link.from(
      [
        _freshLink,
        httpLink,
      ],
    );

    return GraphQLClient(
      link: link,
      cache: cache,
    );
  }
}
