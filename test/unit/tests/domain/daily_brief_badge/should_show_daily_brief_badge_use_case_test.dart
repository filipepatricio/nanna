import 'package:better_informed_mobile/data/util/badge_info_data_source.di.dart';
import 'package:better_informed_mobile/data/util/badge_info_repository_impl.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../generated_mocks.mocks.dart';

void main() {
  late MockSharedPreferences sharedPreferences;
  late BadgeInfoRepository badgeInfoRepository;
  late MockGetActiveSubscriptionUseCase getActiveSubscriptionUseCase;
  late ShouldShowDailyBriefBadgeStateNotifier shouldShowDailyBriefBadgeStateNotifier;
  late ShouldShowDailyBriefBadgeUseCase useCase;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    badgeInfoRepository = BadgeInfoRepositoryImpl(BadgeInfoDataSource(sharedPreferences));
    getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    shouldShowDailyBriefBadgeStateNotifier = ShouldShowDailyBriefBadgeStateNotifier();
    useCase = ShouldShowDailyBriefBadgeUseCase(
      badgeInfoRepository,
      shouldShowDailyBriefBadgeStateNotifier,
      getActiveSubscriptionUseCase,
    );
  });

  test(
    'returns true as default for a premium user',
    () async {
      final activeSubscription = ActiveSubscription.premium(
        DateTime.now(),
        'https://management-url.com',
        DateTime.now(),
        true,
        _createPlan(),
        null,
        SubscriptionOrigin.appStore,
      );

      when(getActiveSubscriptionUseCase.call()).thenAnswer((realInvocation) async => activeSubscription);
      when(sharedPreferences.getBool('shouldShowDailyBriefBadgeKey')).thenAnswer((realInvocation) => null);

      final actual = await useCase();

      expect(actual, true);

      verify(badgeInfoRepository.shouldShowDailyBriefBadge());
    },
  );

  test(
    'returns true as default for a free user',
    () async {
      final activeSubscription = ActiveSubscription.free();

      when(getActiveSubscriptionUseCase.call()).thenAnswer((realInvocation) async => activeSubscription);
      when(sharedPreferences.getBool('shouldShowDailyBriefBadgeKey')).thenAnswer((realInvocation) => null);

      final actual = await useCase();

      expect(actual, true);

      verifyNever(badgeInfoRepository.shouldShowDailyBriefBadge());
    },
  );

  test(
    'returns true for a free user, even if shared preferences is set false',
    () async {
      final activeSubscription = ActiveSubscription.free();

      when(getActiveSubscriptionUseCase.call()).thenAnswer((realInvocation) async => activeSubscription);
      when(sharedPreferences.getBool('shouldShowDailyBriefBadgeKey')).thenAnswer((realInvocation) => false);

      final actual = await useCase();

      expect(actual, true);

      verifyNever(badgeInfoRepository.shouldShowDailyBriefBadge());
    },
  );

  test(
    'returns false for a premium user, when is set false',
    () async {
      final activeSubscription = ActiveSubscription.premium(
        DateTime.now(),
        'https://management-url.com',
        DateTime.now(),
        true,
        _createPlan(),
        null,
        SubscriptionOrigin.appStore,
      );

      when(getActiveSubscriptionUseCase.call()).thenAnswer((realInvocation) async => activeSubscription);
      when(sharedPreferences.getBool('shouldShowDailyBriefBadgeKey')).thenAnswer((realInvocation) => false);

      final actual = await useCase();

      expect(actual, false);

      verify(badgeInfoRepository.shouldShowDailyBriefBadge());
    },
  );
}

SubscriptionPlan _createPlan({String offeringId = 'offeringId', String packageId = 'packageId'}) {
  return SubscriptionPlan(
    type: SubscriptionPlanType.annual,
    description: 'Annual',
    price: 9.99,
    priceString: '9.99',
    monthlyPrice: 0.83,
    monthlyPriceString: '0.83',
    title: 'Premium',
    trialDays: 0,
    reminderDays: 14,
    offeringId: offeringId,
    packageId: packageId,
    productId: 'productId',
  );
}
