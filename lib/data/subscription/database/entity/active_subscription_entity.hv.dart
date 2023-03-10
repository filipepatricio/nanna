import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_origin_entity.hv.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_plan_entity.hv.dart';
import 'package:hive/hive.dart';

part 'active_subscription_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.activeSubscriptionEntity)
class ActiveSubscriptionEntity {
  ActiveSubscriptionEntity(
    this._free,
    this._trial,
    this._premium,
    this._manualPremium,
  );

  ActiveSubscriptionEntity.free()
      : _free = ActiveSubscriptionFreeEntity(),
        _trial = null,
        _premium = null,
        _manualPremium = null;

  ActiveSubscriptionEntity.trial(ActiveSubscriptionTrialEntity trial)
      : _trial = trial,
        _free = null,
        _premium = null,
        _manualPremium = null;

  ActiveSubscriptionEntity.premium(ActiveSubscriptionPremiumEntity premium)
      : _premium = premium,
        _free = null,
        _trial = null,
        _manualPremium = null;

  ActiveSubscriptionEntity.manualPremium(ActiveSubscriptionManualPremiumEntity manualPremium)
      : _manualPremium = manualPremium,
        _free = null,
        _trial = null,
        _premium = null;

  @HiveField(0)
  final ActiveSubscriptionFreeEntity? _free;
  @HiveField(1)
  final ActiveSubscriptionTrialEntity? _trial;
  @HiveField(2)
  final ActiveSubscriptionPremiumEntity? _premium;
  @HiveField(3)
  final ActiveSubscriptionManualPremiumEntity? _manualPremium;

  T map<T>({
    required T Function(ActiveSubscriptionFreeEntity free) free,
    required T Function(ActiveSubscriptionTrialEntity trial) trial,
    required T Function(ActiveSubscriptionPremiumEntity premium) premium,
    required T Function(ActiveSubscriptionManualPremiumEntity manualPremium) manualPremium,
  }) {
    if (_free != null) {
      return free(_free!);
    } else if (_trial != null) {
      return trial(_trial!);
    } else if (_premium != null) {
      return premium(_premium!);
    } else if (_manualPremium != null) {
      return manualPremium(_manualPremium!);
    } else {
      throw Exception('Invalid ActiveSubscriptionEntity');
    }
  }
}

@HiveType(typeId: HiveTypes.activeSubscriptionFreeEntity)
class ActiveSubscriptionFreeEntity {}

@HiveType(typeId: HiveTypes.activeSubscriptionTrialEntity)
class ActiveSubscriptionTrialEntity {
  ActiveSubscriptionTrialEntity({
    required this.purchaseDate,
    required this.manageSubscriptionURL,
    required this.remainingTrialDays,
    required this.plan,
    required this.nextPlan,
    required this.subscriptionOrigin,
  });

  @HiveField(0)
  final String purchaseDate;
  @HiveField(1)
  final String manageSubscriptionURL;
  @HiveField(2)
  final int remainingTrialDays;
  @HiveField(3)
  final SubscriptionPlanEntity plan;
  @HiveField(4)
  final SubscriptionPlanEntity? nextPlan;
  @HiveField(5, defaultValue: SubscriptionOriginEntity.unknown())
  final SubscriptionOriginEntity subscriptionOrigin;
}

@HiveType(typeId: HiveTypes.activeSubscriptionPremiumEntity)
class ActiveSubscriptionPremiumEntity {
  ActiveSubscriptionPremiumEntity({
    required this.purchaseDate,
    required this.manageSubscriptionURL,
    required this.expirationDate,
    required this.willRenew,
    required this.plan,
    required this.nextPlan,
    required this.subscriptionOrigin,
  });

  @HiveField(0)
  final String purchaseDate;
  @HiveField(1)
  final String manageSubscriptionURL;
  @HiveField(2)
  final String? expirationDate;
  @HiveField(3)
  final bool willRenew;
  @HiveField(4)
  final SubscriptionPlanEntity plan;
  @HiveField(5)
  final SubscriptionPlanEntity? nextPlan;
  @HiveField(6, defaultValue: SubscriptionOriginEntity.unknown())
  final SubscriptionOriginEntity subscriptionOrigin;
}

@HiveType(typeId: HiveTypes.activeSubscriptionManualPremiumEntity)
class ActiveSubscriptionManualPremiumEntity {
  ActiveSubscriptionManualPremiumEntity({
    required this.manageSubscriptionURL,
    required this.expirationDate,
  });

  @HiveField(0)
  final String manageSubscriptionURL;
  @HiveField(1)
  final String? expirationDate;
}
