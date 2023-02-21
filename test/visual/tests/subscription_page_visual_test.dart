import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${SubscriptionPage}_(trial)', (tester) async {
    await tester.startApp(initialRoute: const SubscriptionPageRoute());
    await tester.matchGoldenFile();
  });

  visualTest('${SubscriptionPage}_(no_trial)', (tester) async {
    final useCase = FakeGetSubscriptionPlansUseCase(TestData.subscriptionPlansWithoutTrial);
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetSubscriptionPlansUseCase>(() => useCase);
      },
      initialRoute: const SubscriptionPageRoute(),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${SubscriptionPage}_(restore_purchase)', (tester) async {
    final l10n = await AppLocalizations.delegate.load(PhraseLocalizations.supportedLocales.first);
    final useCase = FakeRestorePurchaseUseCase();
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<RestorePurchaseUseCase>(() => useCase);
      },
      initialRoute: const SubscriptionPageRoute(),
    );

    final widgetFinder = find.byWidgetPredicate(
      (widget) => widget is LinkLabel && widget.label == l10n.subscription_restorePurchase,
    );

    await tester.dragUntilVisible(widgetFinder, find.byType(SubscriptionPage), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(widgetFinder);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}

class FakeGetSubscriptionPlansUseCase extends Fake implements GetSubscriptionPlansUseCase {
  FakeGetSubscriptionPlansUseCase(this.plans);

  final List<SubscriptionPlan> plans;

  @override
  Future<SubscriptionPlanGroup> call() async => SubscriptionPlanGroup(plans: plans);
}

class FakeRestorePurchaseUseCase extends Fake implements RestorePurchaseUseCase {
  @override
  Future<bool> call() async => false;
}
