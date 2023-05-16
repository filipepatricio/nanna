import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/manage_my_interests/settings_manage_my_interests_page.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsManageMyInterestsPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsManageMyInterestsPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsManageMyInterestsPage}_(guest)', (tester) async {
    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsManageMyInterestsPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
      },
    );

    await tester.matchGoldenFile();
  });
}
