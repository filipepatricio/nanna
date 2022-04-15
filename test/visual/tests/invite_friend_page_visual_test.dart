import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/invite_friend/invite_friend_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(InviteFriendPage, (tester) async {
    await tester.startApp(initialRoute: const InviteFriendPageRoute());
    await tester.matchGoldenFile();
  });

  visualTest('${InviteFriendPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const InviteFriendPageRoute(),
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          AudioPlayerBannerCubitFake(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
