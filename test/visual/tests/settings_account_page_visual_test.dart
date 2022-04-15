import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/account/settings_account_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsAccountPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsAccountPageRoute());
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsAccountPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const SettingsAccountPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          AudioPlayerBannerCubitFake(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
