import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../finders.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'all available plans are shown in screen',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(find.byType(SubscriptionPlanCard), findsNWidgets(2));
    },
  );
  testWidgets(
    'timeline is shown only for selected plan',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.first.trialDays),
              TestData.subscriptionPlansWithTrial.first.priceString,
              LocaleKeys.subscription_subscriptionTypeName_annual.tr(),
            ],
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.last.trialDays),
              TestData.subscriptionPlansWithTrial.last.priceString,
              LocaleKeys.subscription_subscriptionTypeName_monthly.tr()
            ],
          ),
        ),
        findsNothing,
      );
      await tester.tap(find.byType(SubscriptionPlanCard).last);
      await tester.pumpAndSettle();
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.last.trialDays),
              TestData.subscriptionPlansWithTrial.last.priceString,
              LocaleKeys.subscription_subscriptionTypeName_monthly.tr()
            ],
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.first.trialDays),
              TestData.subscriptionPlansWithTrial.first.priceString,
              LocaleKeys.subscription_subscriptionTypeName_annual.tr(),
            ],
          ),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'footer updates based on selected plan',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      expect(
        find.byText(
          LocaleKeys.subscription_chargeInfo_trial.tr(
            args: [
              LocaleKeys.date_daySuffix.tr(args: ['${TestData.subscriptionPlansWithTrial.first.trialDays}']),
            ],
          ),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(SubscriptionPlanCard).last);
      await tester.pumpAndSettle();
      expect(
        find.byText(
          LocaleKeys.subscription_chargeInfo_trial.tr(
            args: [
              LocaleKeys.date_daySuffix.tr(args: ['${TestData.subscriptionPlansWithTrial.last.trialDays}']),
            ],
          ),
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'subscribe button triggers purchase for selected plan',
    (tester) async {
      await tester.startApp(initialRoute: const SubscriptionPageRoute());
      await tester.tap(find.byType(SubscriptionPlanCard).last);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SubscribeButton && widget.plan.title == TestData.subscriptionPlansWithTrial.last.title,
        ),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'subscription button changes depending on wether plan has trial',
    (tester) async {
      final useCase = FakeGetSubscriptionPlansUseCase();
      await tester.startApp(
        initialRoute: const SubscriptionPageRoute(),
        dependencyOverride: (getIt) async => getIt.registerFactory<GetSubscriptionPlansUseCase>(() => useCase),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is InformedFilledButton && widget.text == LocaleKeys.subscription_button_standard.tr(),
        ),
        findsOneWidget,
      );

      final lastPlan = (await useCase.call()).plans.last;
      await tester.tap(find.byType(SubscriptionPlanCard).last);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InformedFilledButton &&
              widget.text ==
                  LocaleKeys.subscription_button_trialText.tr(
                    args: [
                      LocaleKeys.date_daySuffix.tr(args: ['${lastPlan.trialDays}']),
                    ],
                  ),
          skipOffstage: false,
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
        find.byWidgetPredicate(
          (widget) => widget is InformedMarkdownBody && widget.markdown == LocaleKeys.subscription_title_trial.tr(),
        ),
        findsOneWidget,
      );
    },
  );
}

class FakeGetSubscriptionPlansUseCase extends Fake implements GetSubscriptionPlansUseCase {
  @override
  Future<SubscriptionPlanGroup> call() async {
    return SubscriptionPlanGroup(
      plans: [
        TestData.subscriptionPlansWithoutTrial.first,
        TestData.subscriptionPlansWithTrial.last,
      ],
    );
  }
}
