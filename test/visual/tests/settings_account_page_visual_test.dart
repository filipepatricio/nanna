import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:better_informed_mobile/presentation/widget/link_label.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../generated_mocks.mocks.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsAccountPage, (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsAccountPageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
    await tester.tap(find.byType(LinkLabel));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('settings_account_page_(delete_account)');
  });

  visualTest('${SettingsAccountPage}_(guest)', (tester) async {
    final isGuestModeUseCase = MockIsGuestModeUseCase();
    when(isGuestModeUseCase.call()).thenAnswer((_) async => true);

    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          SettingsAccountPageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<IsGuestModeUseCase>(() => isGuestModeUseCase);
      },
    );

    await tester.matchGoldenFile();
  });
}
