import 'package:better_informed_mobile/data/auth/api/auth_api_data_source.dart';
import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/auth_token_dto_mapper.dart';
import 'package:better_informed_mobile/data/auth/api/provider/oauth_sign_in_data_source.dart';
import 'package:better_informed_mobile/data/util/graphql_response_resolver.dart';
import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final OAuthSignInDataSource _oAuthSignInDataSource;
  final AuthTokenDTOMapper _authTokenDTOMapper;

  AuthRepositoryImpl(
    this._apiDataSource,
    this._oAuthSignInDataSource,
    this._authTokenDTOMapper,
  );

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> requestMagicLink(String email) async {
    final result = await _apiDataSource.sendMagicLink(email);
    GraphQLResponseResolver.resolve(result, (raw) => null, rootKey: null);
  }

  @override
  Future<AuthToken> signInWithDefaultProvider() async {
    final oAuthToken = await _oAuthSignInDataSource.getProviderToken();

    final result = await _apiDataSource.signInWithProvider(oAuthToken.token, oAuthToken.provider);
    if (result.hasException) throw Exception('Signing in failed');

    final dto = GraphQLResponseResolver.resolve(
      result,
      (raw) => AuthTokenDTO.fromJson(raw),
      innerKey: 'signIn',
    );

    if (dto == null) throw Exception('Sign in result is null.');

    return _authTokenDTOMapper.from(dto);
  }
}
