import 'package:better_informed_mobile/data/user_store/store/user_store_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserStore, env: liveEnvs)
class UserStoreImpl implements UserStore {
  final UserDatabase _database;

  UserStoreImpl(this._database);

  @override
  Future<Box<E>> openBox<E>(String boxName) async {
    final userUuid = await _database.getUserLoggedIn();
    final box = await Hive.openBox('${userUuid}_$boxName') as Box<E>;
    return box;
  }

  @override
  Future<void> clear() async {
    await _database.clearUserLoggedIn();
  }

  @override
  Future<void> setLoggedInUserUuid(String userUuid) async {
    await _database.setUserLoggedIn(userUuid);
  }
}
