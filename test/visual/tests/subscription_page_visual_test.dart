import 'package:better_informed_mobile/domain/subscription/use_case/get_subscription_plans_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/subscription/subscription_page.dart';

import '../../fakes.dart';
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
}
