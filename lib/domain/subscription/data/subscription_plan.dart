import 'package:purchases_flutter/object_wrappers.dart';

enum SubscriptionPlanType { annual, monthly }

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
    required this.trialDays,
    required this.reminderDays,
    required this.packageId,
    this.discountPercentage = 0,
  });

  final SubscriptionPlanType type;
  final String title;
  final String description;
  final double price;
  final String priceString;
  final int trialDays;
  final int reminderDays;
  final int discountPercentage;

  final String packageId;

  bool get isAnnual => type == SubscriptionPlanType.annual;
}

SubscriptionPlanType fromPackageType(PackageType type) {
  switch (type) {
    case PackageType.annual:
      return SubscriptionPlanType.annual;
    default:
      return SubscriptionPlanType.monthly;
  }
}
