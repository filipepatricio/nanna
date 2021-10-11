import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart' as article_image;
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_section.dart';
import 'package:better_informed_mobile/domain/topic/data/reading_list.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:injectable/injectable.dart';

final mockedArticleList1 = [
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu',
    type: ArticleType.premium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 5,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: null,
    wordCount: 6687,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8efc4520-f512-4a31-9ba7-c65267e34a0b",
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israels government: End of Netanyahu era?',
    type: ArticleType.premium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 3,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: null,
    wordCount: 587,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8e664720-f512-4a31-9ba7-c65267e34a0b",
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'China allows three children in major policy shift',
    type: ArticleType.premium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 6,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: null,
    wordCount: 1587,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8ef774720-f512-4a31-9ba7-c65267e34a0b",
  ),
];

final mockedArticleList2 = [
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu',
    type: ArticleType.freemium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 5,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: null,
    wordCount: 1687,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8efc4720-f512-4a31-9ba7-c65267e34a0b",
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'Israels government: End of Netanyahu era?',
    type: ArticleType.freemium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 4,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: 'Quos dolorem et eos cum optio sequi nostrum praesentium.',
    wordCount: 1287,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "22333-f512-4a31-9ba7-c65267e34a0b",
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'China allows three children in major policy shift',
    type: ArticleType.freemium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 6,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: null,
    wordCount: 1187,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8e3320-f512-4a31-9ba7-c65267e34a0b",
  ),
  ArticleHeader(
    slug: '2021-07-27-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu',
    title: 'China allows three children in major policy shift',
    type: ArticleType.freemium,
    publicationDate: DateTime.parse('2021-02-08'),
    timeToRead: 11,
    publisher: Publisher(
      name: 'NYT',
      lightLogo: article_image.Image(publicId: 'publishers/the_economist'),
      darkLogo: article_image.Image(publicId: 'publishers/the_economist'),
    ),
    image: article_image.Image(publicId: 'articles/storm'),
    author: 'John Doe',
    note: 'Quos dolorem et eos cum optio sequi nostrum praesentium.',
    wordCount: 687,
    sourceUrl: 'https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html',
    id: "8e3443720-f512-4a31-9ba7-c65267e34a0b",
  ),
];

final exclusiveSection = ExploreContentSection.articleWithCover(
  title: '**Exclusive** news',
  themeColor: AppColors.limeGreen.value,
  coverArticle: mockedArticleList2[0],
  articles: mockedArticleList1,
);

final editorTeamSection = ExploreContentSection.articleWithCover(
  title: 'By our **Editorial team**',
  themeColor: AppColors.pastelGreen.value,
  coverArticle: mockedArticleList1[0],
  articles: mockedArticleList2,
);

final missedArticlesSection = ExploreContentSection.articles(
  title: 'In case you missed',
  themeColor: AppColors.background.value,
  articles: mockedArticleList2,
);

final readingListSection = ExploreContentSection.readingLists(
  title: '**Reading** list',
  topics: [
    Topic(
      id: '0',
      title: 'Afghanistan stories',
      introduction: 'introduction',
      summary: [],
      heroImage: Image(publicId: ''),
      readingList: ReadingList(
        articles: mockedArticleList2,
        id: '0',
      ),
      coverImage: Image(publicId: ''),
    ),
    Topic(
      id: '0',
      title: 'All the crypto coins',
      introduction: 'introduction',
      summary: [],
      heroImage: Image(publicId: ''),
      readingList: ReadingList(
        articles: mockedArticleList1,
        id: '0',
      ),
      coverImage: Image(publicId: ''),
    ),
    Topic(
      id: '0',
      title: 'Female Leadership',
      introduction: 'introduction',
      summary: [],
      heroImage: Image(publicId: ''),
      readingList: ReadingList(
        articles: mockedArticleList2,
        id: '0',
      ),
      coverImage: Image(publicId: ''),
    ),
    Topic(
      id: '0',
      title: 'Afghanistan falls to the Taliban',
      introduction: 'introduction',
      summary: [],
      heroImage: Image(publicId: ''),
      readingList: ReadingList(
        articles: mockedArticleList1,
        id: '0',
      ),
      coverImage: Image(publicId: ''),
    ),
  ],
);

@injectable
class GetExploreContentUseCase {
  Future<ExploreContent> call() async {
    await Future.delayed(const Duration(seconds: 1));

    return ExploreContent(
      sections: [
        exclusiveSection,
        readingListSection,
        missedArticlesSection,
        editorTeamSection,
      ],
    );
  }
}
