import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_sign_in_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:fimber/fimber.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final OAuthSignInDataSource _oAuthSignInDataSource;
  final FreshLink<OAuth2Token> _freshLink;
  final LoginResponseDTOMapper _loginResponseDTOMapper;

  AuthRepositoryImpl(
    this._apiDataSource,
    this._oAuthSignInDataSource,
    this._freshLink,
    this._loginResponseDTOMapper,
  );

  @override
  Future<void> requestMagicLink(String email) async {
    await _apiDataSource.sendMagicLink(email);
  }

  @override
  Future<AuthResult> signInWithDefaultProvider() async {
    final oAuthToken = await _oAuthSignInDataSource.getProviderToken();
    final result = await _apiDataSource.signInWithProvider(oAuthToken.token, oAuthToken.provider, oAuthToken.userMeta);
    final response = _loginResponseDTOMapper(result);

    return AuthResult(response.tokens, oAuthToken.provider, response.user);
  }

  @override
  Future<AuthResult> signInWithMagicLinkToken(String token) async {
    const signInMethod = SignInProviderDTO.informed;
    final result = await _apiDataSource.signInWithProvider(token, signInMethod);
    final response = _loginResponseDTOMapper(result);

    return AuthResult(response.tokens, signInMethod, response.user);
  }

  @override
  Stream<void> tokenExpirationStream() {
    return _freshLink.authenticationStatus
        .distinct((prev, next) => prev == next)
        .where((event) => event == AuthenticationStatus.unauthenticated)
        .map((event) => Fimber.d('Token has been revoked.'));
  }

  @override
  Future<AuthResult> signInWithInviteCode(
    SignInCredentials credentials,
    String code,
  ) async {
    final result = await _apiDataSource.signInWithInviteCode(credentials, code);
    final response = _loginResponseDTOMapper(result);

    return AuthResult(response.tokens, credentials.provider, response.user);
  }
}
