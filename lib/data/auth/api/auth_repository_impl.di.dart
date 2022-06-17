import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/login_response_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/linkedin/linkedin_credential_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_credential_provider_data_source.di.dart';
import 'package:better_informed_mobile/data/auth/api/provider/provider_dto.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:fimber/fimber.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final OAuthCredentialProviderDataSource _oAuthPlatformSignInDataSource;
  final FreshLink<OAuth2Token> _freshLink;
  final LoginResponseDTOMapper _loginResponseDTOMapper;
  final LinkedinCredentialDataSource _linkedinCredentialDataSource;

  AuthRepositoryImpl(
    this._apiDataSource,
    this._oAuthPlatformSignInDataSource,
    this._freshLink,
    this._loginResponseDTOMapper,
    this._linkedinCredentialDataSource,
  );

  @override
  Future<void> requestMagicLink(String email) async {
    await _apiDataSource.sendMagicLink(email);
  }

  @override
  Future<AuthResult> signInWithDefaultProvider() async {
    final oAuthToken = await _oAuthPlatformSignInDataSource.fetchOAuthUser();
    final result = await _apiDataSource.signInWithProvider(
      oAuthToken.token,
      oAuthToken.provider,
      oAuthToken.user,
    );
    final response = _loginResponseDTOMapper(result);

    return AuthResult(response.tokens, oAuthToken.provider, response.user.uuid);
  }

  @override
  Future<AuthResult> signInWithLinkedin() async {
    final oAuthToken = await _linkedinCredentialDataSource.fetchOAuthUser();
    final result = await _apiDataSource.signInWithProvider(
      oAuthToken.token,
      oAuthToken.provider,
    );
    final response = _loginResponseDTOMapper(result);

    return AuthResult(
      response.tokens,
      oAuthToken.provider,
      response.user.uuid,
    );
  }

  @override
  Future<AuthResult> signInWithMagicLinkToken(String token) async {
    const signInMethod = SignInProviderDTO.informed;
    final result = await _apiDataSource.signInWithProvider(token, signInMethod);
    final response = _loginResponseDTOMapper(result);

    return AuthResult(response.tokens, signInMethod, response.user.uuid);
  }

  @override
  Stream<void> tokenExpirationStream() {
    return _freshLink.authenticationStatus
        .distinct((prev, next) => prev == next)
        .where((event) => event == AuthenticationStatus.unauthenticated)
        .map((event) => Fimber.d('Token has been revoked.'));
  }
}
