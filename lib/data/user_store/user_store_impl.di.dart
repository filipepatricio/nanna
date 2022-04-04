import 'package:better_informed_mobile/data/user_store/store/user_store_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserStore, env: liveEnvs)
class UserStoreImpl implements UserStore {
  final UserDatabase _database;

  UserStoreImpl(this._database);

  @override
  Future<String> getCurrentUserUuid() async {
    return await _database.getCurrentUserUuid();
  }

  @override
  Future<void> clearCurrentUserUuid() async {
    await _database.clearCurrentUserUuid();
  }

  @override
  Future<void> setCurrentUserUuid(String userUuid) async {
    await _database.setCurrentUserUuid(userUuid);
  }
}
