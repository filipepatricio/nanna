import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/data/networking/graphql_fresh_link_factory.dart';
import 'package:better_informed_mobile/data/networking/should_refresh_validator.di.dart';
import 'package:better_informed_mobile/data/networking/store/graphql_token_storage.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GraphQLFreshLinkFactory, env: liveEnvs)
class GraphQLFreshLinkFactoryImpl implements GraphQLFreshLinkFactory {
  final RefreshTokenService _refreshTokenService;
  final GraphQLTokenStorage _storage;
  final ShouldRefreshValidator _shouldRefreshValidator;

  GraphQLFreshLinkFactoryImpl(
    this._refreshTokenService,
    this._storage,
    this._shouldRefreshValidator,
  );

  @override
  Future<FreshLink<OAuth2Token>> create() async {
    final link = FreshLink.oAuth2(
      tokenStorage: _storage,
      refreshToken: (token, client) async {
        final refreshToken = token?.refreshToken;
        if (token == null || refreshToken == null) return null;

        return _refreshTokenService.refreshToken(refreshToken);
      },
      shouldRefresh: _shouldRefreshValidator,
    );

    await link.authenticationStatus.where((event) => event != AuthenticationStatus.initial).first;

    return link;
  }
}
