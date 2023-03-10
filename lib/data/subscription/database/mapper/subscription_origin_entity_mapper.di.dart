import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_origin_entity.hv.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscriptionOriginEntityMapper implements BidirectionalMapper<SubscriptionOriginEntity, SubscriptionOrigin> {
  @override
  SubscriptionOriginEntity from(SubscriptionOrigin data) {
    switch (data) {
      case SubscriptionOrigin.appStore:
        return const SubscriptionOriginEntity.appStore();
      case SubscriptionOrigin.playStore:
        return const SubscriptionOriginEntity.playStore();
      default:
        return const SubscriptionOriginEntity.unknown();
    }
  }

  @override
  SubscriptionOrigin to(SubscriptionOriginEntity data) {
    return data.map(
      appStore: (appStore) => SubscriptionOrigin.appStore,
      playStore: (playStore) => SubscriptionOrigin.playStore,
      unknown: (unknown) => SubscriptionOrigin.unknown,
    );
  }
}
