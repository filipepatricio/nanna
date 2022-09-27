import 'package:better_informed_mobile/exports.dart';
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
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.first.trialDays),
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
              LocaleKeys.date_day.plural(TestData.subscriptionPlansWithTrial.last.trialDays),
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
}
