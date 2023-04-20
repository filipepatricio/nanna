import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_origin.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes.dart';
import '../../../finders.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

const currentOfferingKey = 'current';

void main() {
  late AppLocalizations l10n;

  setUp(() async {
    l10n = await AppLocalizations.delegate.load(PhraseLocalizations.supportedLocales.first);
  });

  testWidgets(
    'all available plans are shown in screen',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(find.byType(SubscriptionPlanCell), findsNWidgets(2));
    },
  );
  testWidgets(
    'timeline is shown only for selected plan',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(
        find.byText(
          l10n.subscription_trialTimeline_step1_title,
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'subscribe button triggers purchase for selected plan',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      await tester.tap(find.byType(SubscriptionPlanCell).last);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SubscribeButton && widget.selectedPlan.title == TestData.subscriptionPlansWithTrial.last.title,
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'no trial version of subscription page is shown when not all plans have trial',
    (tester) async {
      final useCase = FakeGetSubscriptionPlansUseCase();
      await tester.startApp(
        initialRoute: const SubscriptionPageRoute(),
        dependencyOverride: (getIt) async => getIt.registerFactory<GetSubscriptionPlansUseCase>(() => useCase),
      );
      expect(
        find.byWidgetPredicate((widget) => widget is SubscriptionPlansView && !widget.trialViewMode),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'trial version of subscription page is shown when all plans have trials',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(
        find.byText(
          l10n.subscription_subscribeWithTrial,
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'when user has subscribed plan, show change title and confirm button',
    (tester) async {
      final premiumSubscription = ActiveSubscription.premium(
        DateTime.now(),
        'https://management-url.com',
        DateTime.now(),
        true,
        _createPlan(offeringId: currentOfferingKey, packageId: 'packageId'),
        null,
        SubscriptionOrigin.appStore,
      );
      final useCase = FakeGetActiveSubscriptionUseCase(
        activeSubscription: premiumSubscription,
      );
      await tester.startApp(
        initialRoute: const SubscriptionPageRoute(),
        dependencyOverride: (getIt) async => getIt.registerFactory<GetActiveSubscriptionUseCase>(() => useCase),
      );
      expect(
        find.byText(
          l10n.subscription_change_title,
        ),
        findsOneWidget,
      );
      expect(
        find.byText(
          l10n.subscription_change_confirm,
        ),
        findsOneWidget,
      );
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
