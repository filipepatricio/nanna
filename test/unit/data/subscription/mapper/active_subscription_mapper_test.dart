import 'package:better_informed_mobile/data/subscription/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:purchases_flutter/object_wrappers.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late ActiveSubscriptionMapper activeSubscriptionMapper;

  setUp(() {
    activeSubscriptionMapper = ActiveSubscriptionMapper(AppConfig.dev);
  });

  test('returns free plan for user without any entitlements', () {
    final customer = MockCustomerInfo();
    final subscription = ActiveSubscriptionDTO(customer: customer, plans: []);

    when(customer.entitlements).thenReturn(const EntitlementInfos({}, {}));

    final result = activeSubscriptionMapper(subscription);

    expect(result, ActiveSubscription.free());
  });

  test('returns trial plan for user with active entitlement and trial period type', () {
    const activeEntitlement = EntitlementInfo(
      'identifier',
      true,
      true,
      '2022-01-08',
      '2022-01-08',
      'productIdentifier',
      true,
      expirationDate: '2022-01-10',
      periodType: PeriodType.trial,
    );

    final customer = MockCustomerInfo();
    final activePlan = MockSubscriptionPlan();
    final subscription = ActiveSubscriptionDTO(
      customer: customer,
      plans: [
        activePlan,
      ],
    );

    when(customer.entitlements).thenReturn(
      EntitlementInfos(
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
      ),
    );
    when(customer.allPurchaseDates).thenReturn(
      {
        activeEntitlement.productIdentifier: activeEntitlement.latestPurchaseDate,
      },
    );
    when(activePlan.productId).thenReturn(activeEntitlement.productIdentifier);
    when(customer.managementURL).thenReturn('www.google.com');

    withClock(Clock.fixed(DateTime(2022, 01, 8)), () {
      final result = activeSubscriptionMapper(subscription);

      expect(
        result,
        ActiveSubscription.trial(
          DateTime(2022, 01, 8),
          customer.managementURL!,
          2,
          activePlan,
          null,
        ),
      );
    });
  });

  test('returns premium plan for user with active entitlement and normal period type', () {
    const activeEntitlement = EntitlementInfo(
      'identifier',
      true,
      true,
      '2022-01-08',
      '2022-01-08',
      'productIdentifier',
      true,
      expirationDate: '2022-01-10',
      periodType: PeriodType.normal,
    );

    final customer = MockCustomerInfo();
    final activePlan = MockSubscriptionPlan();
    final subscription = ActiveSubscriptionDTO(
      customer: customer,
      plans: [
        activePlan,
      ],
    );

    when(customer.entitlements).thenReturn(
      EntitlementInfos(
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
      ),
    );
    when(activePlan.productId).thenReturn(activeEntitlement.productIdentifier);
    when(customer.managementURL).thenReturn('www.google.com');

    withClock(Clock.fixed(DateTime(2022, 01, 8)), () {
      final result = activeSubscriptionMapper(subscription);

      expect(
        result,
        ActiveSubscription.premium(
          DateTime(2022, 01, 8),
          customer.managementURL!,
          DateTime(2022, 01, 10),
          activeEntitlement.willRenew,
          activePlan,
          null,
        ),
      );
    });
  });

  test(
      'returns manual premium plan for user with active entitlement and without corresponding plan identifier in plan list',
      () {
    const activeEntitlement = EntitlementInfo(
      'identifier',
      true,
      true,
      '2022-01-08',
      '2022-01-08',
      'productIdentifier',
      true,
      expirationDate: '2022-01-10',
      periodType: PeriodType.normal,
    );

    final customer = MockCustomerInfo();
    final activePlan = MockSubscriptionPlan();
    final subscription = ActiveSubscriptionDTO(
      customer: customer,
      plans: [
        activePlan,
      ],
    );

    when(customer.entitlements).thenReturn(
      EntitlementInfos(
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
        {AppConfig.dev.revenueCatPremiumEntitlementId!: activeEntitlement},
      ),
    );
    when(activePlan.productId).thenReturn('different-identifier');
    when(customer.managementURL).thenReturn('www.google.com');

    withClock(Clock.fixed(DateTime(2022, 01, 8)), () {
      final result = activeSubscriptionMapper(subscription);

      expect(
        result,
        ActiveSubscription.manualPremium(
          customer.managementURL!,
          DateTime(2022, 01, 10),
        ),
      );
    });
  });
}
