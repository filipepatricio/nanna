import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
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
      // expect(find.byText(LocaleKeys.signIn_providerButton_apple.tr()), findsOneWidget);
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
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.first.trialDays),
            ],
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.last.trialDays),
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
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.last.trialDays),
            ],
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byText(
          LocaleKeys.subscription_youllBeCharged.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.first.trialDays),
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
          LocaleKeys.subscription_youllBeChargedFooter.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.first.trialDays),
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
          LocaleKeys.subscription_youllBeChargedFooter.tr(
            args: [
              LocaleKeys.date_day.plural(TestData.subscriptionPlans.last.trialDays),
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
          (widget) =>
              widget is SubscribeButton && widget.cubit.selectedPlan.title == TestData.subscriptionPlans.last.title,
        ),
        findsOneWidget,
      );
    },
  );
}
