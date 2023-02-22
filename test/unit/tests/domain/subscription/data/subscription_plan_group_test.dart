import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const plans = [
    SubscriptionPlan(
      type: SubscriptionPlanType.annual,
      title: 'Annual',
      description: 'Annual sub',
      price: 20,
      priceString: '20.0',
      monthlyPrice: 1.67,
      monthlyPriceString: '1.67',
      trialDays: 14,
      reminderDays: 7,
      offeringId: '000',
      packageId: '000',
      productId: '000',
    ),
    SubscriptionPlan(
      type: SubscriptionPlanType.monthly,
      title: 'Monthly',
      description: 'Monthly sub',
      price: 5,
      priceString: '5.0',
      monthlyPrice: 5,
      monthlyPriceString: '5.0',
      trialDays: 7,
      reminderDays: 7,
      offeringId: '000',
      packageId: '001',
      productId: '001',
    ),
  ];

  group('highestMonthlyCostPlan', () {
    test('returns the plan with the highest monthly cost', () {
      const group = SubscriptionPlanGroup(plans: plans);

      expect(group.highestMonthlyCostPlan, plans[1]);
    });
  });

  group('hasTrial', () {
    test('returns true if all plans have a trial', () {
      const group = SubscriptionPlanGroup(plans: plans);

      expect(group.hasTrail, true);
    });

    test('returns false if any plan does not have a trial', () {
      const plans = [
        SubscriptionPlan(
          type: SubscriptionPlanType.annual,
          title: 'Annual',
          description: 'Annual sub',
          price: 20,
          priceString: '20.0',
          monthlyPrice: 1.67,
          monthlyPriceString: '1.67',
          trialDays: 14,
          reminderDays: 7,
          offeringId: '000',
          packageId: '000',
          productId: '000',
        ),
        SubscriptionPlan(
          type: SubscriptionPlanType.monthly,
          title: 'Monthly',
          description: 'Monthly sub',
          price: 5,
          priceString: '5.0',
          monthlyPrice: 5,
          monthlyPriceString: '5.0',
          trialDays: 0,
          reminderDays: 7,
          offeringId: '000',
          packageId: '001',
          productId: '001',
        ),
      ];

      const group = SubscriptionPlanGroup(plans: plans);

      expect(group.hasTrail, false);
    });
  });
}
