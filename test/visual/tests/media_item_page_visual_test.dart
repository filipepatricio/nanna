import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/exception/article_geoblocked_exception.dart';
import 'package:better_informed_mobile/domain/article/use_case/get_article_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/premium_article/premium_article_actions_bar.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:flutter_test/flutter_test.dart';

import '../visual_test_utils.dart';

void main() {
  visualTest(MediaItemPage, (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: MockDTO.premiumArticleWithAudio.slug),
        ],
      ),
    );
    await tester.matchGoldenFile('media_item_page_(image)');
    await tester.tap(find.byType(AnimatedPointerDown).last);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(content)');
    await tester.flingFrom(const Offset(0, 400.0), const Offset(0, -20000), 100);
    await tester.pumpAndSettle();
    await tester.matchGoldenFile('media_item_page_(bottom)');
  });

  visualTest('${MediaItemPage}_(audio)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(slug: MockDTO.premiumArticleWithAudio.slug),
        ],
      ),
    );
    await tester.tap(find.byType(AudioButton));
    await tester.pumpAndSettle();
    await tester.matchGoldenFile();
  });

  visualTest('${MediaItemPage}_(geoblocked)', (tester) async {
    await tester.startApp(
      initialRoute: MainPageRoute(
        children: [
          MediaItemPageRoute(
            slug: '',
          ),
        ],
      ),
      dependencyOverride: (getIt) async {
        getIt.registerFactory<GetArticleUseCase>(() => GetArticleUseCaseFake());
      },
    );
    await tester.matchGoldenFile();
  });
}

class GetArticleUseCaseFake extends Fake implements GetArticleUseCase {
  @override
  Future<Article> call(MediaItemArticle article) => throw ArticleGeoblockedException();
}
