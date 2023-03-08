import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_subscription.dt.freezed.dart';

@Freezed(toJson: false)
class ActiveSubscription with _$ActiveSubscription {
  factory ActiveSubscription.free() = _ActiveSubscriptionFree;

  factory ActiveSubscription.trial(
    DateTime purchaseDate,
    String manageSubscriptionURL,
    int remainingTrialDays,
    SubscriptionPlan plan,
    SubscriptionPlan? nextPlan,
    SubscriptionOrigin origin,
  ) = ActiveSubscriptionTrial;

  factory ActiveSubscription.premium(
    DateTime purchaseDate,
    String manageSubscriptionURL,
    DateTime? expirationDate,
    bool willRenew,
    SubscriptionPlan plan,
    SubscriptionPlan? nextPlan,
    SubscriptionOrigin origin,
  ) = ActiveSubscriptionPremium;

  factory ActiveSubscription.manualPremium(
    String manageSubscriptionURL,
    DateTime? expirationDate,
  ) = ActiveSubscriptionManualPremium;
}

extension IsPremium on ActiveSubscription {
  bool get isPremium => !isFree;

  bool get isFree => maybeMap(
        free: (_) => true,
        orElse: () => false,
      );
}
