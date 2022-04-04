import 'package:better_informed_mobile/data/auth/store/auth_token_database.di.dart';
import 'package:better_informed_mobile/data/networking/store/auth_token_entity_to_oauth_mapper.di.dart';
import 'package:fresh_graphql/fresh_graphql.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLTokenStorage implements TokenStorage<OAuth2Token> {
  final AuthTokenDatabase _authTokenDatabase;
  final AuthTokenEntityToOAuthMapper _authTokenEntityToOAuthMapper;

  GraphQLTokenStorage(
    this._authTokenDatabase,
    this._authTokenEntityToOAuthMapper,
  );

  @override
  Future<void> delete() async {
    await _authTokenDatabase.delete();
  }

  @override
  Future<OAuth2Token?> read() async {
    final entity = await _authTokenDatabase.load();

    if (entity == null) return null;

    return _authTokenEntityToOAuthMapper.to(entity);
  }

  @override
  Future<void> write(OAuth2Token token) async {
    final entity = _authTokenEntityToOAuthMapper.from(token);
    await _authTokenDatabase.save(entity);
  }
}
