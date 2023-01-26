import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_plan_type_entity.hv.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:injectable/injectable.dart';

const _map = {
  SubscriptionPlanType.monthly: 'monthly',
  SubscriptionPlanType.annual: 'annual',
};

@injectable
class SubscriptionPlanTypeEntityMapper
    implements BidirectionalMapper<SubscriptionPlanTypeEntity, SubscriptionPlanType> {
  @override
  SubscriptionPlanTypeEntity from(SubscriptionPlanType data) {
    return SubscriptionPlanTypeEntity(name: _map[data]!);
  }

  @override
  SubscriptionPlanType to(SubscriptionPlanTypeEntity data) {
    return _map.entries.firstWhere((e) => e.value == data.name).key;
  }
}
