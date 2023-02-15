import 'package:purchases_flutter/object_wrappers.dart';

enum SubscriptionPlanType { annual, monthly }

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.priceString,
    required this.monthlyPrice,
    required this.monthlyPriceString,
    required this.trialDays,
    required this.reminderDays,
    required this.offeringId,
    required this.packageId,
    required this.productId,
    this.discountPercentage = 0,
  });

  final SubscriptionPlanType type;
  final String title;
  final String description;
  final double price;
  final String priceString;
  final double monthlyPrice;
  final String monthlyPriceString;
  final int trialDays;
  final int reminderDays;
  final int discountPercentage;

  final String offeringId;
  final String packageId;
  final String productId;

  bool get isAnnual => type == SubscriptionPlanType.annual;

  bool get hasTrial => trialDays > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionPlan &&
        other.offeringId == offeringId &&
        other.packageId == packageId &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return offeringId.hashCode ^ packageId.hashCode ^ productId.hashCode;
  }
}

SubscriptionPlanType fromPackageType(PackageType type) {
  switch (type) {
    case PackageType.annual:
      return SubscriptionPlanType.annual;
    default:
      return SubscriptionPlanType.monthly;
  }
}
