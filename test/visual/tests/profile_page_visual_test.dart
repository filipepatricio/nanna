import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/profile/profile_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
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

  visualTest('${ProfilePage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const ProfileTabGroupRouter(
        children: [
          ProfilePageRoute(),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          AudioPlayerBannerCubitFake(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
