import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_plan_entity.hv.dart';
import 'package:better_informed_mobile/data/subscription/database/mapper/subscription_plan_type_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:injectable/injectable.dart';

@injectable
class SubscriptionPlanEntityMapper implements BidirectionalMapper<SubscriptionPlanEntity, SubscriptionPlan> {
  SubscriptionPlanEntityMapper(this._subscriptionPlanTypeEntityMapper);

  final SubscriptionPlanTypeEntityMapper _subscriptionPlanTypeEntityMapper;

  @override
  SubscriptionPlanEntity from(SubscriptionPlan data) {
    return SubscriptionPlanEntity(
      type: _subscriptionPlanTypeEntityMapper.from(data.type),
      title: data.title,
      description: data.description,
      price: data.price,
      priceString: data.priceString,
      monthlyPrice: data.monthlyPrice,
      monthlyPriceString: data.monthlyPriceString,
      trialDays: data.trialDays,
      reminderDays: data.reminderDays,
      discountPercentage: data.discountPercentage,
      offeringId: data.offeringId,
      packageId: data.packageId,
      productId: data.productId,
    );
  }

  @override
  SubscriptionPlan to(SubscriptionPlanEntity data) {
    return SubscriptionPlan(
      type: _subscriptionPlanTypeEntityMapper.to(data.type),
      title: data.title,
      description: data.description,
      price: data.price,
      priceString: data.priceString,
      monthlyPrice: data.monthlyPrice,
      monthlyPriceString: data.monthlyPriceString,
      trialDays: data.trialDays,
      reminderDays: data.reminderDays,
      discountPercentage: data.discountPercentage,
      offeringId: data.offeringId,
      packageId: data.packageId,
      productId: data.productId,
    );
  }
}
