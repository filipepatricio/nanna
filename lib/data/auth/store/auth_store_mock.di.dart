import 'package:better_informed_mobile/data/auth/store/auth_token_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/networking/store/auth_token_entity_to_oauth_mapper.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthStore, env: mockEnvs)
class AuthStoreMock implements AuthStore {
  final AuthTokenEntityMapper _authTokenEntityMapper;
  final AuthTokenEntityToOAuthMapper _authTokenEntityToOAuthMapper;

  AuthStoreMock(
    this._authTokenEntityMapper,
    this._authTokenEntityToOAuthMapper,
  );

  @override
  Future<void> delete() async {
    return;
  }

  @override
  Future<AuthToken?> read() async {
    const oauthToken = OAuth2Token(accessToken: 'accessToken', refreshToken: 'refreshToken');
    final entity = _authTokenEntityToOAuthMapper.from(oauthToken);
    return _authTokenEntityMapper.from(entity);
  }

  @override
  Future<void> save(AuthToken token) async {
    return;
  }
}
