import 'package:better_informed_mobile/data/push_notification/store/mapper/registered_push_token_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/push_notification/store/push_notification_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/push_notification/data/registered_push_token.dart';
import 'package:better_informed_mobile/domain/push_notification/push_notification_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PushNotificationStore, env: liveEnvs)
class PushNotificationStoreImpl implements PushNotificationStore {
  PushNotificationStoreImpl(this._database, this._entityMapper);
  final PushNotificationDatabase _database;
  final RegisteredPushTokenEntityMapper _entityMapper;

  @override
  Future<void> save(RegisteredPushToken registeredPushToken) async {
    final entity = _entityMapper.from(registeredPushToken);
    await _database.save(entity);
  }

  @override
  Future<RegisteredPushToken?> load() async {
    final entity = await _database.load();

    if (entity == null) return null;

    return _entityMapper.to(entity);
  }

  @override
  Future<void> clear() => _database.clear();
}
