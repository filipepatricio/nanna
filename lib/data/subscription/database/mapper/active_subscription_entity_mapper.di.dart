import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/active_subscription_entity.hv.dart';
import 'package:better_informed_mobile/data/subscription/database/mapper/subscription_origin_entity_mapper.di.dart';
import 'package:better_informed_mobile/data/subscription/database/mapper/subscription_plan_entity_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class ActiveSubscriptionEntityMapper implements BidirectionalMapper<ActiveSubscriptionEntity, ActiveSubscription> {
  ActiveSubscriptionEntityMapper(
    this._subscriptionPlanEntityMapper,
    this._subscriptionOriginEntityMapper,
  );

  final SubscriptionPlanEntityMapper _subscriptionPlanEntityMapper;
  final SubscriptionOriginEntityMapper _subscriptionOriginEntityMapper;

  @override
  ActiveSubscriptionEntity from(ActiveSubscription data) {
    return data.map(
      free: (free) => ActiveSubscriptionEntity.free(),
      trial: (trial) {
        final nextPlan = trial.nextPlan;

        return ActiveSubscriptionEntity.trial(
          ActiveSubscriptionTrialEntity(
            manageSubscriptionURL: trial.manageSubscriptionURL,
            purchaseDate: trial.purchaseDate.toIso8601String(),
            remainingTrialDays: trial.remainingTrialDays,
            plan: _subscriptionPlanEntityMapper.from(trial.plan),
            nextPlan: nextPlan != null ? _subscriptionPlanEntityMapper.from(nextPlan) : null,
            subscriptionOrigin: _subscriptionOriginEntityMapper.from(trial.origin),
          ),
        );
      },
      premium: (premium) {
        final nextPlan = premium.nextPlan;

        return ActiveSubscriptionEntity.premium(
          ActiveSubscriptionPremiumEntity(
            manageSubscriptionURL: premium.manageSubscriptionURL,
            purchaseDate: premium.purchaseDate.toIso8601String(),
            expirationDate: premium.expirationDate?.toIso8601String(),
            willRenew: premium.willRenew,
            plan: _subscriptionPlanEntityMapper.from(premium.plan),
            nextPlan: nextPlan != null ? _subscriptionPlanEntityMapper.from(nextPlan) : null,
            subscriptionOrigin: _subscriptionOriginEntityMapper.from(premium.origin),
          ),
        );
      },
      manualPremium: (manualPremium) => ActiveSubscriptionEntity.manualPremium(
        ActiveSubscriptionManualPremiumEntity(
          manageSubscriptionURL: manualPremium.manageSubscriptionURL,
          expirationDate: manualPremium.expirationDate?.toIso8601String(),
        ),
      ),
    );
  }

  @override
  ActiveSubscription to(ActiveSubscriptionEntity data) {
    return data.map(
      free: (free) => ActiveSubscription.free(),
      trial: (trial) {
        final nextPlan = trial.nextPlan;

        return ActiveSubscription.trial(
          DateTime.parse(trial.purchaseDate),
          trial.manageSubscriptionURL,
          trial.remainingTrialDays,
          _subscriptionPlanEntityMapper.to(trial.plan),
          nextPlan != null ? _subscriptionPlanEntityMapper.to(nextPlan) : null,
          _subscriptionOriginEntityMapper.to(trial.subscriptionOrigin),
        );
      },
      premium: (premium) {
        final nextPlan = premium.nextPlan;
        final expirationDate = premium.expirationDate;

        return ActiveSubscription.premium(
          DateTime.parse(premium.purchaseDate),
          premium.manageSubscriptionURL,
          expirationDate != null ? DateTime.parse(expirationDate) : null,
          premium.willRenew,
          _subscriptionPlanEntityMapper.to(premium.plan),
          nextPlan != null ? _subscriptionPlanEntityMapper.to(nextPlan) : null,
          _subscriptionOriginEntityMapper.to(premium.subscriptionOrigin),
        );
      },
      manualPremium: (manualPremium) {
        final expirationDate = manualPremium.expirationDate;

        return ActiveSubscription.manualPremium(
          manualPremium.manageSubscriptionURL,
          expirationDate != null ? DateTime.parse(expirationDate) : null,
        );
      },
    );
  }
}
