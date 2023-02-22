import 'package:better_informed_mobile/domain/feature_flags/feature_flags_repository.dart';
import 'package:better_informed_mobile/domain/subscription/data/article_paywall_subscription_plan_pack.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/purchases_repository.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_article_paywall_preferred_plan_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_preferred_subscription_plan_use_case.di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../generated_mocks.mocks.dart';

void main() {
  late PurchasesRepository purchasesRepository;
  late FeaturesFlagsRepository featuresFlagsRepository;
  late GetPreferredSubscriptionPlanUseCase getPreferredSubscriptionPlanUseCase;
  late GetArticlePaywallPreferredPlanUseCase useCase;

  setUp(() {
    purchasesRepository = MockPurchasesRepository();
    getPreferredSubscriptionPlanUseCase = MockGetPreferredSubscriptionPlanUseCase();
    featuresFlagsRepository = MockFeaturesFlagsRepository();
    useCase = GetArticlePaywallPreferredPlanUseCase(
      purchasesRepository,
      getPreferredSubscriptionPlanUseCase,
      featuresFlagsRepository,
    );
  });

  test('returns trial plan if at least one plan has a trial', () async {
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
    final expected = ArticlePaywallSubscriptionPlanPack.singleTrial(plans[0]);

    const currentOfferingKey = 'current';
    when(featuresFlagsRepository.defaultPaywall()).thenAnswer((_) async => currentOfferingKey);
    when(purchasesRepository.getSubscriptionPlans(offeringId: currentOfferingKey)).thenAnswer((_) async => plans);
    when(getPreferredSubscriptionPlanUseCase(plans)).thenAnswer((_) => plans[0]);

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
        monthlyPrice: 1.67,
        monthlyPriceString: '1.67',
        trialDays: 0,
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
    final expected = ArticlePaywallSubscriptionPlanPack.multiple(const SubscriptionPlanGroup(plans: plans));

    const currentOfferingKey = 'current';
    when(featuresFlagsRepository.defaultPaywall()).thenAnswer((_) async => currentOfferingKey);
    when(purchasesRepository.getSubscriptionPlans(offeringId: currentOfferingKey)).thenAnswer((_) async => plans);

    final result = await useCase();

    expect(result, equals(expected));
  });
}
