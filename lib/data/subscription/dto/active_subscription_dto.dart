import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:purchases_flutter/object_wrappers.dart';

class ActiveSubscriptionDTO {
  const ActiveSubscriptionDTO({
    required this.customer,
    required this.plans,
  });

  final CustomerInfo customer;
  final List<SubscriptionPlan> plans;
}
