import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsMainPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsMainPageRoute());
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsMainPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const SettingsMainPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          AudioPlayerBannerCubitFake(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
