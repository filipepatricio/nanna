import 'package:better_informed_mobile/domain/tutorial/use_case/is_tutorial_step_seen_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ProfilePage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          ProfilePageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest(
    '${ProfilePage}_(tutorial_snack_bar)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ProfileTabGroupRouter(
          children: [
            ProfilePageRoute(),
          ],
        ),
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
}
