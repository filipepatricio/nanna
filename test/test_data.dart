import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';

class TestData {
  const TestData._();

  static MediaItemArticle get articleMock => MediaItem.article(
        id: 'id',
        slug: 'slug',
        url: '',
        title: 'How golden tests changed my life',
        strippedTitle: 'How golden tests changed my life',
        credits: 'This article originally appeared here',
        type: ArticleType.premium,
        timeToRead: 0,
        publisher: Publisher(darkLogo: null, lightLogo: null, name: 'New York Times'),
        sourceUrl: 'sourceUrl',
        author: 'John Adams',
        image: Image(publicId: 'id'),
      ) as MediaItemArticle;
}
