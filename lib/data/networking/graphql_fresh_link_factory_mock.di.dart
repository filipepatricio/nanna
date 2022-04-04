import 'package:better_informed_mobile/data/auth/api/refresh_token_service.di.dart';
import 'package:better_informed_mobile/data/networking/graphql_fresh_link_factory.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

const oAuth2Token = OAuth2Token(accessToken: 'accessToken', refreshToken: 'refreshToken');

@LazySingleton(as: GraphQLFreshLinkFactory, env: mockEnvs)
class GraphQLFreshLinkFactoryMock implements GraphQLFreshLinkFactory {
  // ignore: unused_field
  final RefreshTokenService _refreshTokenService;

  // Need this dependency to force get_it to register this mock impl further down,
  // and make sure its dependent gets registered only after all implementations of this class are registered
  GraphQLFreshLinkFactoryMock(this._refreshTokenService);

  @override
  Future<FreshLink<OAuth2Token>> create() async {
    return FreshLink.oAuth2(
      tokenStorage: MockTokenStorage(),
      refreshToken: (_, __) async {},
      shouldRefresh: (_) => false,
    );
  }
}

class MockTokenStorage implements TokenStorage<OAuth2Token> {
  @override
  Future<void> delete() async {
    return;
  }

  @override
  Future<OAuth2Token?> read() async {
    return oAuth2Token;
  }

  @override
  Future<void> write(OAuth2Token token) async {
    return;
  }
}
