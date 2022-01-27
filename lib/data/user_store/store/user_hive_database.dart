import 'package:better_informed_mobile/data/user_store/store/user_store_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'userBox';
const _userKey = 'userKey';

@LazySingleton(as: UserDatabase, env: liveEnvs)
class UserHiveDatabase implements UserDatabase {
  @override
  Future<void> clearUserLoggedIn() async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.clear();
  }

  @override
  Future<String> getUserLoggedIn() async {
    final box = await Hive.openBox(_hiveBoxName);
    final userUuid = box.get(_userKey) as String?;
    return userUuid ?? '';
  }

  @override
  Future<void> setUserLoggedIn(String userUuid) async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.put(_userKey, userUuid);
  }
}
