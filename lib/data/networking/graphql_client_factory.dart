import 'package:better_informed_mobile/data/auth/api/refresh_token_service.dart';
import 'package:better_informed_mobile/data/networking/store/graphql_token_storage.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLClientFactory {
  final RefreshTokenService _refreshTokenService;
  final AppConfig _appConfig;
  final GraphQLTokenStorage _storage;
  final AuthStore _authStore;

  GraphQLClientFactory(
    this._refreshTokenService,
    this._appConfig,
    this._storage,
    this._authStore,
  );

  GraphQLClient create() {
    final cache = GraphQLCache(store: InMemoryStore());

    final httpLink = HttpLink(_appConfig.apiUrl);

    final refreshLink = FreshLink.oAuth2(
      tokenStorage: _storage,
      refreshToken: (token, client) async {
        final refreshToken = token?.refreshToken;

        if (token == null || refreshToken == null) return null;

        return _refreshTokenService.refreshToken(refreshToken);
      },
      shouldRefresh: (response) {
        return false;
      },
    );

    final authLink = AuthLink(getToken: () async {
      final token = await _authStore.read();
      if (token == null) return null;

      return 'Bearer ${token.accessToken}';
    });

    final link = Link.from(
      [
        authLink,
        refreshLink,
        httpLink,
      ],
    );

    return GraphQLClient(
      link: link,
      cache: cache,
    );
  }
}
