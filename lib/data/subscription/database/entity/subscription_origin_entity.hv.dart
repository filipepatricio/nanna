import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'subscription_origin_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.subscriptionOriginEntity)
class SubscriptionOriginEntity {
  const SubscriptionOriginEntity(this.name);

  const SubscriptionOriginEntity.appStore() : this('appStore');

  const SubscriptionOriginEntity.playStore() : this('playStore');

  const SubscriptionOriginEntity.unknown() : this('unknown');

  @HiveField(0)
  final String name;

  T map<T>({
    required T Function(SubscriptionOriginEntity appStore) appStore,
    required T Function(SubscriptionOriginEntity playStore) playStore,
    required T Function(SubscriptionOriginEntity unknown) unknown,
  }) {
    switch (name) {
      case 'appStore':
        return appStore(this);
      case 'playStore':
        return playStore(this);
      case 'unknown':
        return unknown(this);
      default:
        throw Exception('Unknown SubscriptionOriginEntity: $name');
    }
  }
}
