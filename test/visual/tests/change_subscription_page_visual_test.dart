import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page_cubit.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/subscription/change_subscription/change_subscription_page_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ChangeSubscriptionPage, (tester) async {
    await tester.startApp(
      initialRoute: const ChangeSubscriptionPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<ChangeSubscriptionPageCubit>(
          () => FakeChangeSubscriptionPageCubit(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}

class FakeChangeSubscriptionPageCubit extends Fake implements ChangeSubscriptionPageCubit {
  @override
  final SubscriptionPlan? currentPlan = TestData.subscriptionPlansWithoutTrial.first;
  @override
  final SubscriptionPlan nextPlan = TestData.subscriptionPlansWithoutTrial.last;
  @override
  final SubscriptionPlan selectedPlan = TestData.subscriptionPlansWithoutTrial.last;

  final idle = ChangeSubscriptionPageState.idle(
    plans: TestData.subscriptionPlansWithoutTrial,
    subscription: TestData.activeSubscriptionTrial,
  );

  @override
  ChangeSubscriptionPageState get state => idle;

  @override
  Stream<ChangeSubscriptionPageState> get stream => Stream.value(idle);

  @override
  Future<void> initialize() async {}

  @override
  Future<void> close() async {}
}
