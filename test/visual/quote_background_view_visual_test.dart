import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.gr.dart';
import 'package:better_informed_mobile/presentation/widget/share/quote/quote_background_view.dart';

import '../flutter_test_config.dart';
import 'visual_test_utils.dart';

void main() {
  final articleMock = MediaItem.article(
    id: 'id',
    slug: 'slug',
    url: '',
    title: 'How golden tests changed my life',
    strippedTitle: 'How golden tests changed my life',
    type: ArticleType.premium,
    timeToRead: 0,
    publisher: Publisher(darkLogo: null, lightLogo: null, name: 'New York Times'),
    sourceUrl: 'sourceUrl',
    author: 'John Adams',
    image: Image(publicId: 'id'),
  ) as MediaItemArticle;

  visualTest(
    QuoteBackgroundView,
    (tester) async {
      await tester.startApp(
        initialRoute: PlaceholderPageRoute(
          child: QuoteBackgroundView(
            article: articleMock,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.matchGoldenFile();
    },
    testConfig: stickerDevice,
  );
}
