import 'package:better_informed_mobile/data/auth/store/auth_token_database.dart';
import 'package:better_informed_mobile/data/auth/store/auth_token_entity_mapper.dart';
import 'package:better_informed_mobile/domain/auth/auth_store.dart';
import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthStore)
class AuthStoreImpl implements AuthStore {
  final AuthTokenDatabase _database;
  final AuthTokenEntityMapper _authTokenEntityMapper;

  AuthStoreImpl(this._database, this._authTokenEntityMapper);

  @override
  Future<void> delete() async {
    await _database.delete();
  }

  @override
  Future<AuthToken?> read() async {
    final entity = await _database.load();

    if (entity == null) return null;

    return _authTokenEntityMapper.from(entity);
  }

  @override
  Future<void> save(AuthToken token) async {
    final entity = _authTokenEntityMapper.to(token);
    await _database.save(entity);
  }
}
