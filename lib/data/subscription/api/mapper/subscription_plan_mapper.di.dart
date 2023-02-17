import 'dart:math' as math;

import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/subscription/api/dto/offering_dto.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

@injectable
class SubscriptionPlanMapper implements Mapper<OfferingDTO, List<SubscriptionPlan>> {
  @override
  List<SubscriptionPlan> call(OfferingDTO dto) {
    final plans = <SubscriptionPlan>[];
    final offering = dto.offering;

    for (final package in offering.availablePackages) {
      final format = NumberFormat.compactSimpleCurrency(name: package.storeProduct.currencyCode);

      plans.add(
        SubscriptionPlan(
          type: fromPackageType(package.packageType),
          title: package.storeProduct.title,
          description: package.storeProduct.description,
          price: package.storeProduct.price,
          priceString: package.storeProduct.priceString,
          monthlyPrice: package.monthlyPrice,
          monthlyPriceString: format.format(package.monthlyPrice),
          trialDays: dto.isFirstTimeSubscriber ? package.trialDays : 0,
          reminderDays: dto.isFirstTimeSubscriber ? package.reminderDays : 0,
          discountPercentage: package.discountPercentage(offering),
          offeringId: offering.identifier,
          packageId: package.identifier,
          productId: package.storeProduct.identifier,
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

  double get monthlyPrice {
    var factor = 1.0;

    switch (packageType) {
      case PackageType.monthly:
        factor = 1;
        break;
      case PackageType.weekly:
        factor = 0.25;
        break;
      case PackageType.sixMonth:
        factor = 6;
        break;
      case PackageType.threeMonth:
        factor = 3;
        break;
      case PackageType.twoMonth:
        factor = 2;
        break;
      case PackageType.annual:
        factor = 12;
        break;
      default:
        break;
    }

    return storeProduct.price / factor;
  }

  int discountPercentage(Offering offering) =>
      ((1 - (annualizedPrice / offering.annualizedPrices.reduce(math.max))) * 100).truncate();
}
