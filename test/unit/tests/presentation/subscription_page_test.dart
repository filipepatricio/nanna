import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/widgets/subscription_plans_view.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscribe_button.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_cell.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fakes.dart';
import '../../../finders.dart';
import '../../../flutter_test_config.dart';
import '../../../test_data.dart';
import '../../unit_test_utils.dart';

const currentOfferingKey = 'current';

void main() {
  group('general', () {
    testWidgets(
      'all available plans are shown in screen',
      (tester) async {
        await tester.startApp(initialRoute: const SubscriptionPageRoute());
        expect(find.byType(SubscriptionPlanCell), findsNWidgets(2));
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
                widget is SubscribeButton &&
                widget.selectedPlan.title == TestData.subscriptionPlansWithTrial.last.title,
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('trial', () {
    testWidgets(
      'timeline is shown for selected plan',
      (tester) async {
        final annualPlan = TestData.subscriptionPlansWithTrial.first;
        final monthlyPlan = TestData.subscriptionPlansWithTrial.last;

        final useCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());
        await tester.startApp(
          initialRoute: const SubscriptionPageRoute(),
          dependencyOverride: (getIt) async => getIt.registerFactory<GetActiveSubscriptionUseCase>(() => useCase),
        );

        final annualLabelFinder = find.byText(
          l10n.subscription_trialTimeline_title(annualPlan.trialDays),
          skipOffstage: false,
        );

        final monthlyLabelFinder = find.byText(
          l10n.subscription_trialTimeline_title(monthlyPlan.trialDays),
          skipOffstage: false,
        );

        expect(annualLabelFinder, findsOneWidget);
        expect(monthlyLabelFinder, findsNothing);

        final otherPlanCellFinder = find.byType(SubscriptionPlanCell).last;

        await tester.ensureVisible(otherPlanCellFinder);
        await tester.pumpAndSettle();
        await tester.tap(otherPlanCellFinder);
        await tester.pumpAndSettle();

        expect(annualLabelFinder, findsNothing);
        expect(monthlyLabelFinder, findsOneWidget);
      },
    );

    testWidgets(
      'trial version of subscription page is shown when all plans have trials and user is not subscribed',
      (tester) async {
        final useCase = FakeGetActiveSubscriptionUseCase(activeSubscription: ActiveSubscription.free());
        await tester.startApp(
          initialRoute: const SubscriptionPageRoute(),
          dependencyOverride: (getIt) async => getIt.registerFactory<GetActiveSubscriptionUseCase>(() => useCase),
        );

        expect(find.byText(l10n.subscription_button_trialText), findsOneWidget);
      },
    );
  });

  group('no trial', () {
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
  });

  group('change plan', () {
    testWidgets(
      'show change title and confirm button',
      (tester) async {
        final useCase = FakeGetActiveSubscriptionUseCase(activeSubscription: TestData.activeSubscription);
        await tester.startApp(
          initialRoute: const SubscriptionPageRoute(),
          dependencyOverride: (getIt) async => getIt.registerFactory<GetActiveSubscriptionUseCase>(() => useCase),
        );
        expect(find.byText(l10n.subscription_change_title), findsOneWidget);
        expect(find.byText(l10n.subscription_change_confirm), findsOneWidget);
      },
    );
    testWidgets(
      'disable confirm button if selected plan is current plan',
      (tester) async {
        final useCase = FakeGetActiveSubscriptionUseCase(activeSubscription: TestData.activeSubscription);
        await tester.startApp(
          initialRoute: const SubscriptionPageRoute(),
          dependencyOverride: (getIt) async => getIt.registerFactory<GetActiveSubscriptionUseCase>(() => useCase),
        );

        expect(
          find.byWidgetPredicate((widget) => widget is SubscribeButton && widget.isEnabled),
          findsOneWidget,
        );

        final otherPlanCellFinder = find.byType(SubscriptionPlanCell).last;
        await tester.ensureVisible(otherPlanCellFinder);
        await tester.pumpAndSettle();
        await tester.tap(otherPlanCellFinder);
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate((widget) => widget is SubscribeButton && !widget.isEnabled),
          findsOneWidget,
        );
      },
    );
  });
}
