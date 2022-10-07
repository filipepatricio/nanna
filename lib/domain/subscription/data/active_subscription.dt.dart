import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_subscription.dt.freezed.dart';

@freezed
class ActiveSubscription with _$ActiveSubscription {
  factory ActiveSubscription.free() = _ActiveSubscriptionFree;

  factory ActiveSubscription.trial(
    DateTime purchaseDate,
    String manageSubscriptionURL,
    int remainingTrialDays,
    SubscriptionPlan plan,
  ) = ActiveSubscriptionTrial;

  factory ActiveSubscription.premium(
    DateTime purchaseDate,
    String manageSubscriptionURL,
    DateTime? expirationDate,
    bool willRenew,
    SubscriptionPlan plan,
  ) = ActiveSubscriptionPremium;

  factory ActiveSubscription.manualPremium(
    String manageSubscriptionURL,
    DateTime? expirationDate,
    bool willRenew,
  ) = ActiveSubscriptionManualPremium;
}
