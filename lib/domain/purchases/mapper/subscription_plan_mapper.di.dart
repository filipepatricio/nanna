import 'dart:math' as math;

import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/purchases/data/subscription_plan.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class SubscriptionPlanMapper implements Mapper<Offering, List<SubscriptionPlan>> {
  @override
  List<SubscriptionPlan> call(Offering offering) {
    final plans = <SubscriptionPlan>[];
    for (final package in offering.availablePackages) {
      plans.add(
        SubscriptionPlan(
          type: fromPackageType(package.packageType),
          title: package.storeProduct.title,
          description: package.storeProduct.description,
          price: package.storeProduct.price,
          priceString: package.storeProduct.priceString,
          trialDays: package.trialDays,
          reminderDays: package.reminderDays,
          discountPercentage: package.discountPercentage(offering),
          packageId: package.identifier,
        ),
      );
    }
    return plans;
  }
}

extension on Offering {
  Iterable<double> get annualizedPrices => availablePackages.map((package) => package.annualizedPrice);
}

extension on Package {
  int get trialDays {
    final trial = storeProduct.introductoryPrice;
    if (trial == null) return 0;

    var factor = 1;
    switch (trial.periodUnit) {
      case PeriodUnit.day:
      case PeriodUnit.unknown:
        break;
      case PeriodUnit.year:
        factor = 365;
        break;
      case PeriodUnit.month:
        factor = 30;
        break;
      case PeriodUnit.week:
        factor = 7;
        break;
    }

    return trial.periodNumberOfUnits * factor;
  }

  int get reminderDays => (trialDays / 2).truncate();

  double get annualizedPrice {
    var factor = 1;
    switch (packageType) {
      case PackageType.monthly:
        factor = 12;
        break;
      case PackageType.weekly:
        factor = 52;
        break;
      case PackageType.sixMonth:
        factor = 2;
        break;
      case PackageType.threeMonth:
        factor = 4;
        break;
      case PackageType.twoMonth:
        factor = 6;
        break;
      default:
        break;
    }
    return storeProduct.price * factor;
  }

  int discountPercentage(Offering offering) =>
      ((1 - (annualizedPrice / offering.annualizedPrices.reduce(math.max))) * 100).truncate();
}