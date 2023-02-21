import 'package:better_informed_mobile/domain/subscription/data/subscription_plan_group.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../finders.dart';
import '../../flutter_test_config.dart';
import '../../generated_mocks.mocks.dart';
import '../../test_data.dart';
import '../unit_test_utils.dart';

void main() {
  testWidgets(
    'no upcoming plan is labeled, when not available',
    (tester) async {
      await tester.startApp(initialRoute: const ChangeSubscriptionPageRoute());
      expect(find.byText(l10n.subscription_change_currentPlan), findsOneWidget);
      expect(find.byText(l10n.subscription_change_upcomingPlan), findsNothing);
    },
  );
  testWidgets(
    'upcoming plan is correctly labeled, when available',
    (tester) async {
      final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      final getSubscriptionPlansUseCase = MockGetSubscriptionPlansUseCase();

      when(getSubscriptionPlansUseCase())
          .thenAnswer((_) async => SubscriptionPlanGroup(plans: TestData.subscriptionPlansWithoutTrial));

      final subscription = TestData.activeSubscription.copyWith(nextPlan: TestData.subscriptionPlansWithoutTrial.first);
      when(getActiveSubscriptionUseCase()).thenAnswer((_) async => subscription);

      await tester.startApp(
        initialRoute: const ChangeSubscriptionPageRoute(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
          getIt.registerFactory<GetSubscriptionPlansUseCase>(() => getSubscriptionPlansUseCase);
        },
      );

      expect(find.byText(l10n.subscription_change_currentPlan), findsOneWidget);
      expect(find.byText(l10n.subscription_change_upcomingPlan), findsOneWidget);
    },
  );
}
