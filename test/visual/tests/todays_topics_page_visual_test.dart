import 'package:better_informed_mobile/presentation/page/todays_topics/todays_topics_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_cubit.di.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(TodaysTopicsPage, (tester) async {
    await tester.startApp();
    await tester.matchGoldenFile('todays_topics_page_(topic_card)');
    await tester.fling(find.byType(TopicCover).first, const Offset(0, -10000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('todays_topics_page_(relax)');
  });

  visualTest('${TodaysTopicsPage}_(audio_banner)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<AudioPlayerBannerCubit>(
          FakeAudioPlayerBannerCubit(),
        );
      },
    );
    await tester.fling(find.byType(TopicCover).first, const Offset(0, -10000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${TodaysTopicsPage}_(covers_with_photo)', (tester) async {
    await tester.startApp(
      dependencyOverride: (getIt) async {
        getIt.registerSingleton<TopicCoverCubit>(
          FakeTopicCoverCubit(),
        );
      },
    );
    await tester.matchGoldenFile();
  });
}
