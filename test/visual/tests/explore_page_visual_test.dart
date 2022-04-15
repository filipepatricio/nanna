import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/explore_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ExplorePage, (tester) async {
    await tester.startApp(
      initialRoute: const ExploreTabGroupRouter(
        children: [
          ExplorePageRoute(),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${ExplorePage}_(audio_banner)', (tester) async {
    await tester.startApp(
      initialRoute: const ExploreTabGroupRouter(
        children: [
          ExplorePageRoute(),
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

  visualTest(
    '${ExplorePage}_(full_height)',
    (tester) async {
      await tester.startApp(
        initialRoute: const ExploreTabGroupRouter(
          children: [
            ExplorePageRoute(),
          ],
        ),
      );
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([veryHighDevice]),
  );
}
