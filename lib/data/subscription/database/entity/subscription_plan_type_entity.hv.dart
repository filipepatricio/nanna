import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'subscription_plan_type_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.subscriptionPlanTypeEntity)
class SubscriptionPlanTypeEntity {
  SubscriptionPlanTypeEntity({required this.name});

  @HiveField(0)
  final String name;
}
