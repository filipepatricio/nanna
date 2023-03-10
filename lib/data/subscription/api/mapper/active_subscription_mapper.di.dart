import 'dart:collection';

import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/subscription/api/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/data/subscription/api/mapper/subscription_origin_mapper.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class ActiveSubscriptionMapper implements Mapper<ActiveSubscriptionDTO, ActiveSubscription> {
  ActiveSubscriptionMapper(
    this._appConfig,
    this._subscriptionOriginMapper,
  );

  final AppConfig _appConfig;
  final SubscriptionOriginMapper _subscriptionOriginMapper;

  @override
  ActiveSubscription call(ActiveSubscriptionDTO dto) {
    final activeEntitlement = dto.customer.entitlements.active[_appConfig.revenueCatPremiumEntitlementId];

    if (activeEntitlement == null) {
      return ActiveSubscription.free();
    }

    final plans = dto.plans;

    final activePlan = plans.firstWhereOrNull((plan) => plan.productId == activeEntitlement.productIdentifier);
    if (activePlan != null) {
      // Checking wether the user has recently made a plan change, and is coming into effect upon expiration date
      final nextPlan = _getNextPlanIfExists(dto.customer, plans, activePlan);

      if (activeEntitlement.periodType == PeriodType.trial || activeEntitlement.periodType == PeriodType.intro) {
        return ActiveSubscription.trial(
          DateTime.parse(activeEntitlement.originalPurchaseDate),
          dto.customer.managementURL ?? '',
          DateTime.parse(activeEntitlement.expirationDate!).difference(clock.now()).inDays,
          activePlan,
          nextPlan,
          _subscriptionOriginMapper(activeEntitlement.store),
        );
      }

      return ActiveSubscription.premium(
        DateTime.parse(activeEntitlement.originalPurchaseDate),
        dto.customer.managementURL ?? '',
        activeEntitlement.expirationDate != null ? DateTime.parse(activeEntitlement.expirationDate!) : null,
        activeEntitlement.willRenew,
        activePlan,
        nextPlan,
        _subscriptionOriginMapper(activeEntitlement.store),
      );
    }

    return ActiveSubscription.manualPremium(
      dto.customer.managementURL ?? '',
      activeEntitlement.expirationDate != null ? DateTime.parse(activeEntitlement.expirationDate!) : null,
    );
  }

  SubscriptionPlan? _getNextPlanIfExists(
    CustomerInfo customer,
    List<SubscriptionPlan> plans,
    SubscriptionPlan activePlan,
  ) {
    final invertedPurchasesMap = customer.allPurchaseDates.map(
      (productId, date) => MapEntry<String, String>(date, productId),
    );
    final orderedPurchases = SplayTreeMap<String, String>.from(invertedPurchasesMap);
    final lastPurchasedPlan = plans.firstWhereOrNull((plan) => plan.productId == orderedPurchases.entries.last.value);
    return lastPurchasedPlan?.productId == activePlan.productId ? null : lastPurchasedPlan;
  }
}
