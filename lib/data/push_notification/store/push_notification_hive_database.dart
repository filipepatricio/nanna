import 'package:better_informed_mobile/data/push_notification/store/entity/registered_push_token_entity.dart';
import 'package:better_informed_mobile/data/push_notification/store/push_notification_database.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'pushNotificationBox';
const _tokenKey = 'tokenKey';
const _updatedAtKey = 'updatedAtKey';

@LazySingleton(as: PushNotificationDatabase)
class PushNotificationHiveDatabase implements PushNotificationDatabase {
  @override
  Future<void> save(RegisteredPushTokenEntity entity) async {
    final box = await Hive.openBox(_hiveBoxName);

    await box.putAll(
      {
        _tokenKey: entity.token,
        _updatedAtKey: entity.updatedAt,
      },
    );
  }

  @override
  Future<RegisteredPushTokenEntity?> load() async {
    final box = await Hive.openBox(_hiveBoxName);

    final token = box.get(_tokenKey) as String?;
    final updatedAt = box.get(_updatedAtKey) as int?;

    if (token == null || updatedAt == null) return null;

    return RegisteredPushTokenEntity(token: token, updatedAt: updatedAt);
  }

  @override
  Future<void> clear() async {
    final box = await Hive.openBox(_hiveBoxName);
    await box.clear();
  }
}
