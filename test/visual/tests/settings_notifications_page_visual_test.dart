import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/settings_notifications_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(SettingsNotificationsPage, (tester) async {
    await tester.startApp(initialRoute: const SettingsNotificationsPageRoute());
    await tester.matchGoldenFile();
  });

  visualTest('${SettingsNotificationsPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const SettingsNotificationsPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          AudioPlayerBannerCubitFake(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
