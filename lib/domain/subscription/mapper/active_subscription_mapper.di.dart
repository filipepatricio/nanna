import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/subscription/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class ActiveSubscriptionMapper implements Mapper<ActiveSubscriptionDTO, ActiveSubscription> {
  ActiveSubscriptionMapper(this._appConfig);

  final AppConfig _appConfig;

  @override
  ActiveSubscription call(ActiveSubscriptionDTO dto) {
    final activeEntitlement = dto.customer.entitlements.active[_appConfig.revenueCatPremiumEntitlementId];
    if (activeEntitlement == null) {
      return ActiveSubscription.free();
    }

    final plans = dto.plans;

    if (plans.any((element) => element.productId == activeEntitlement.productIdentifier)) {
      final activePlan = plans.firstWhere((plan) => plan.productId == activeEntitlement.productIdentifier);

      if (activeEntitlement.periodType == PeriodType.trial || activeEntitlement.periodType == PeriodType.intro) {
        return ActiveSubscription.trial(
          DateTime.parse(activeEntitlement.originalPurchaseDate),
          dto.customer.managementURL ?? '',
          DateTime.parse(activeEntitlement.expirationDate!).difference(clock.now()).inDays,
          activePlan,
        );
      }

      return ActiveSubscription.premium(
        DateTime.parse(activeEntitlement.originalPurchaseDate),
        dto.customer.managementURL ?? '',
        activeEntitlement.expirationDate != null ? DateTime.parse(activeEntitlement.expirationDate!) : null,
        activeEntitlement.willRenew,
        activePlan,
      );
    }

    return ActiveSubscription.manualPremium(
      dto.customer.managementURL ?? '',
      activeEntitlement.expirationDate != null ? DateTime.parse(activeEntitlement.expirationDate!) : null,
      activeEntitlement.willRenew,
    );
  }
}
