import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGraphQLClientFactory {
  final AppConfig _config;

  AuthGraphQLClientFactory(this._config);

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());
    final httpLink = HttpLink(_config.apiUrl);

    return GraphQLClient(
      cache: cache,
      link: Link.from(
        [
          httpLink,
        ],
      ),
    );
  }
}
