import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page.dart';
import 'package:mockito/mockito.dart';

import '../../fakes.dart';
import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ProfilePage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(),
    );
    await tester.matchGoldenFile();
  });

  visualTest(
    '${ProfilePage}_(tutorial_snack_bar)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<IsTutorialStepSeenUseCase>(
            () => FakeIsTutorialStepSeenUseCase(isStepSeen: false),
          );
        },
      );
      await tester.matchGoldenFile();
      await tester.pumpAndSettle(const Duration(seconds: 5));
    },
  );

  visualTest(
    '${ProfilePage}_(free_user_banner)',
    (tester) async {
      final getActiveSubscriptionUseCase = MockGetActiveSubscriptionUseCase();
      when(getActiveSubscriptionUseCase.call()).thenAnswer((_) async => ActiveSubscription.free());
      when(getActiveSubscriptionUseCase.stream).thenAnswer((_) => Stream.value(ActiveSubscription.free()));

      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(),
        dependencyOverride: (getIt) async {
          getIt.registerFactory<GetActiveSubscriptionUseCase>(() => getActiveSubscriptionUseCase);
        },
      );
      await tester.matchGoldenFile();
    },
  );
}
