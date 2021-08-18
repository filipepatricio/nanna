import 'package:better_informed_mobile/data/auth/api/refresh_token_service.dart';
import 'package:better_informed_mobile/data/networking/should_refresh_validator.dart';
import 'package:better_informed_mobile/data/networking/store/graphql_token_storage.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphqlFreshLinkFactory {
  final RefreshTokenService _refreshTokenService;
  final GraphQLTokenStorage _storage;
  final ShouldRefreshValidator _shouldRefreshValidator;

  GraphqlFreshLinkFactory(
    this._refreshTokenService,
    this._storage,
    this._shouldRefreshValidator,
  );

  FreshLink<OAuth2Token> create() {
    return FreshLink.oAuth2(
      tokenStorage: _storage,
      refreshToken: (token, client) async {
        final refreshToken = token?.refreshToken;

        if (token == null || refreshToken == null) return null;

        return _refreshTokenService.refreshToken(refreshToken);
      },
      shouldRefresh: _shouldRefreshValidator,
    );
  }
}
