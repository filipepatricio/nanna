import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/restore_purchase_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';
import 'package:better_informed_mobile/presentation/widget/filled_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fakes.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest('${SubscriptionPage}_(trial)', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.startApp(initialRoute: const SubscriptionPageRoute());
    await tester.matchGoldenFile();
    debugDefaultTargetPlatformOverride = null;
  });

  visualTest('${SubscriptionPage}_(no_trial)', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final useCase = FakeGetSubscriptionPlansUseCase(TestData.subscriptionPlansWithoutTrial);
    final activeSubscriptionUseCase = FakeGetActiveSubscriptionUseCase(
      activeSubscription: ActiveSubscription.free(),
    );
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetSubscriptionPlansUseCase>(() => useCase);
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => activeSubscriptionUseCase);
      },
      initialRoute: const SubscriptionPageRoute(),
    );
    await tester.matchGoldenFile();
    debugDefaultTargetPlatformOverride = null;
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
      (widget) => widget is InformedFilledButton && widget.text == l10n.subscription_restorePurchase,
    );

    await tester.dragUntilVisible(widgetFinder, find.byType(SubscriptionPage), const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(widgetFinder);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });

  visualTest('${SubscriptionPage}_(change_plan)', (tester) async {
    final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
    final getSubscriptionPlansUseCase = MockGetSubscriptionPlansUseCase();

    final subscription = TestData.activeSubscription.copyWith(
      plan: TestData.subscriptionPlansWithoutTrial.first,
      nextPlan: TestData.subscriptionPlansWithoutTrial.last,
    );

    when(getSubscriptionPlansUseCase()).thenAnswer(
      (_) async => SubscriptionPlanGroup(plans: [subscription.plan, subscription.nextPlan!]),
    );

    when(getActiveSubscriptionUseCase()).thenAnswer((_) async => subscription);
    when(getActiveSubscriptionUseCase.stream).thenAnswer((realInvocation) => const Stream.empty());

    await tester.startApp(
      initialRoute: const SubscriptionPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        getIt.registerFactory<GetSubscriptionPlansUseCase>(() => getSubscriptionPlansUseCase);
      },
    );

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
