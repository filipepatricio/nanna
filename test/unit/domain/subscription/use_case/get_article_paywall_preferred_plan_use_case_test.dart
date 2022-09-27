import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_article_paywall_preferred_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late PurchasesRepository purchasesRepository;
  late GetPreferredSubscriptionPlanUseCase getPreferredSubscriptionPlanUseCase;
  late GetArticlePaywallPreferredPlanUseCase useCase;

  setUp(() {
    purchasesRepository = MockPurchasesRepository();
    getPreferredSubscriptionPlanUseCase = MockGetPreferredSubscriptionPlanUseCase();
    useCase = GetArticlePaywallPreferredPlanUseCase(purchasesRepository, getPreferredSubscriptionPlanUseCase);
  });

  test('returns trial plan if at least one plan has a trial', () async {
    const plans = [
      SubscriptionPlan(
        type: SubscriptionPlanType.annual,
        title: 'Annual',
        description: 'Annual sub',
        price: 20,
        priceString: '20.0',
        trialDays: 14,
        reminderDays: 7,
        packageId: '000',
        productId: '000',
      ),
      SubscriptionPlan(
        type: SubscriptionPlanType.monthly,
        title: 'Monthly',
        description: 'Monthly sub',
        price: 5,
        priceString: '5.0',
        trialDays: 7,
        reminderDays: 7,
        packageId: '001',
        productId: '001',
      ),
    ];
    final expected = ArticlePaywallSubscriptionPlanPack.singleTrial(plans[0]);

    when(purchasesRepository.getSubscriptionPlans()).thenAnswer((realInvocation) async => plans);
    when(getPreferredSubscriptionPlanUseCase(plans)).thenAnswer((realInvocation) => plans[0]);

    final result = await useCase();

    expect(result, equals(expected));
  });

  test('returns multiple plans if none plan has a trial', () async {
    const plans = [
      SubscriptionPlan(
        type: SubscriptionPlanType.annual,
        title: 'Annual',
        description: 'Annual sub',
        price: 20,
        priceString: '20.0',
        trialDays: 0,
        reminderDays: 7,
        packageId: '000',
        productId: '000',
      ),
      SubscriptionPlan(
        type: SubscriptionPlanType.monthly,
        title: 'Monthly',
        description: 'Monthly sub',
        price: 5,
        priceString: '5.0',
        trialDays: 0,
        reminderDays: 7,
        packageId: '001',
        productId: '001',
      ),
    ];
    final expected = ArticlePaywallSubscriptionPlanPack.multiple(plans);

    when(purchasesRepository.getSubscriptionPlans()).thenAnswer((realInvocation) async => plans);

    final result = await useCase();

    expect(result, equals(expected));
  });
}
