import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/page/settings/widgets/settings_main_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsMainPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsMainPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsMainPage}_(guest)', (tester) async {
    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsMainPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
      },
    );

    await tester.tap(find.byType(SettingsMainItem).first);
    await tester.pumpAndSettle();

    await tester.matchGoldenFile();
  });
}
