import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:better_informed_mobile/data/subscription/database/entity/subscription_plan_type_entity.hv.dart';
import 'package:hive/hive.dart';

part 'subscription_plan_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.subscriptionPlanEntity)
class SubscriptionPlanEntity {
  SubscriptionPlanEntity({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
    required this.trialDays,
    required this.reminderDays,
    required this.discountPercentage,
    required this.offeringId,
    required this.packageId,
    required this.productId,
  });

  @HiveField(0)
  final SubscriptionPlanTypeEntity type;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final double price;
  @HiveField(4)
  final String priceString;
  @HiveField(5)
  final int trialDays;
  @HiveField(6)
  final int reminderDays;
  @HiveField(7)
  final int discountPercentage;
  @HiveField(8)
  final String offeringId;
  @HiveField(9)
  final String packageId;
  @HiveField(10)
  final String productId;
}
