import 'package:better_informed_mobile/data/auth/api/dto/token_data_dto.dt.dart';
import 'package:better_informed_mobile/data/auth/api/mapper/token_data_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/auth/store/auth_token_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/store/auth_token_entity_to_oauth_mapper.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/auth/data/token_data.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

@LazySingleton(as: AuthStore, env: liveEnvs)
class AuthStoreImpl implements AuthStore {
  AuthStoreImpl(
    this._freshLink,
    this._authTokenEntityMapper,
    this._authTokenEntityToOAuthMapper,
    this._tokenContentDTOMapper,
  );

  final FreshLink<OAuth2Token> _freshLink;
  final AuthTokenEntityMapper _authTokenEntityMapper;
  final AuthTokenEntityToOAuthMapper _authTokenEntityToOAuthMapper;
  final TokenDataDTOMapper _tokenContentDTOMapper;

  @override
  Future<void> delete() async {
    await _freshLink.clearToken();
  }

  @override
  Future<AuthToken?> read() async {
    final oauthToken = await _freshLink.token;

    if (oauthToken == null) return null;

    final entity = _authTokenEntityToOAuthMapper.from(oauthToken);
    return _authTokenEntityMapper.from(entity);
  }

  @override
  Future<void> save(AuthToken token) async {
    final entity = _authTokenEntityMapper.to(token);
    final oauthToken = _authTokenEntityToOAuthMapper.to(entity);
    await _freshLink.setToken(oauthToken);
  }

  @override
  Future<TokenData?> accessTokenData() async {
    final authToken = await read();
    if (authToken == null) {
      return null;
    }

    final decodedToken = JwtDecoder.tryDecode(authToken.accessToken);
    if (decodedToken == null) {
      return null;
    }

    return _tokenContentDTOMapper(TokenDataDTO.fromJson(decodedToken));
  }
}
