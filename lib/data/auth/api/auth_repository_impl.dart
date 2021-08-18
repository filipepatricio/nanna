import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_sign_in_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:fimber/fimber.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final OAuthSignInDataSource _oAuthSignInDataSource;
  final AuthTokenDTOMapper _authTokenDTOMapper;
  final FreshLink<OAuth2Token> _freshLink;

  AuthRepositoryImpl(
    this._apiDataSource,
    this._oAuthSignInDataSource,
    this._authTokenDTOMapper,
    this._freshLink,
  );

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> requestMagicLink(String email) async {
    await _apiDataSource.sendMagicLink(email);
  }

  @override
  Future<AuthToken> signInWithDefaultProvider() async {
    final oAuthToken = await _oAuthSignInDataSource.getProviderToken();
    final result = await _apiDataSource.signInWithProvider(oAuthToken.token, oAuthToken.provider);

    return _authTokenDTOMapper.from(result);
  }

  @override
  Future<AuthToken> signInWithMagicLinkToken(String token) async {
    final result = await _apiDataSource.signInWithProvider(token, SignInProviderDTO.informed);

    return _authTokenDTOMapper.from(result);
  }

  @override
  Stream<void> tokenExpirationStream() {
    return _freshLink.authenticationStatus
        .distinct((prev, next) => prev == next)
        .where((event) => event == AuthenticationStatus.unauthenticated)
        .map((event) => Fimber.d('Token has been revoked.'));
  }
}
