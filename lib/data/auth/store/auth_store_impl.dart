import 'package:better_informed_mobile/data/auth/store/auth_token_entity_mapper.dart';
import 'package:better_informed_mobile/data/networking/store/auth_token_entity_to_oauth_mapper.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthStore, env: liveEnvs)
class AuthStoreImpl implements AuthStore {
  final FreshLink<OAuth2Token> _freshLink;
  final AuthTokenEntityMapper _authTokenEntityMapper;
  final AuthTokenEntityToOAuthMapper _authTokenEntityToOAuthMapper;

  AuthStoreImpl(
    this._freshLink,
    this._authTokenEntityMapper,
    this._authTokenEntityToOAuthMapper,
  );

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
}
