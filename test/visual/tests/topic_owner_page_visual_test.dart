import 'package:better_informed_mobile/presentation/page/topic/owner/topic_owner_page.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(
    TopicOwnerPage,
    (tester) async {
      await tester.startApp(initialRoute: TopicPage(topicSlug: ''));
      await tester.tap(find.byType(TopicOwnerAvatar).last);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: TestConfig.unitTesting.withDevices([highDevice]),
  );

  visualTest(
    '${TopicOwnerPage}_(audio_banner)',
    (tester) async {
      await tester.startApp(
        initialRoute: TopicPage(topicSlug: ''),
        dependencyOverride: (getIt) async {
          getIt.registerSingleton<AudioPlayerBannerCubit>(
            AudioPlayerBannerCubitFake(),
          );
        },
      );
      await tester.tap(find.byType(TopicOwnerAvatar).last);
      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
  );
}
