import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page.dart';
import 'package:better_informed_mobile/presentation/widget/subscription/subscription_plan_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ChangeSubscriptionPage, (tester) async {
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
      initialRoute: const ChangeSubscriptionPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        getIt.registerFactory<GetSubscriptionPlansUseCase>(() => getSubscriptionPlansUseCase);
      },
    );

    await tester.tap(find.byType(SubscriptionPlanCard).last);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
