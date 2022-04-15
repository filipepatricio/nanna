import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/explore/see_all/article/article_see_all_page.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';

import '../../test_data.dart';
import '../visual_test_utils.dart';

void main() {
  visualTest(ArticleSeeAllPage, (tester) async {
    final area = TestData.exploreContent.areas.firstWhere(
      (area) => area is ExploreContentAreaArticleWithFeature,
    ) as ExploreContentAreaArticleWithFeature;

    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          ArticleSeeAllPageRoute(
            areaId: area.id,
            title: area.title,
            entries: area.articles,
          ),
        ],
      ),
    );
    await tester.matchGoldenFile();
  });

  visualTest('${ArticleSeeAllPage}_(audio_banner)', (tester) async {
    final area = TestData.exploreContent.areas.firstWhere(
      (area) => area is ExploreContentAreaArticleWithFeature,
    ) as ExploreContentAreaArticleWithFeature;

    await tester.startApp(
      initialRoute: ExploreTabGroupRouter(
        children: [
          ArticleSeeAllPageRoute(
            areaId: area.id,
            title: area.title,
            entries: area.articles,
          ),
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
