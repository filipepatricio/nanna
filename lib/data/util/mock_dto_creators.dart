import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_data_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_dto.dart';
import 'package:better_informed_mobile/data/bookmark/dto/bookmark_list_dto.dart';
import 'package:better_informed_mobile/data/audio_file/api/dto/audio_file_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/current_brief_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_style_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/reading_list_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/summary_card_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_owner_dto.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';

/// To be use as a response for mock implementations of remote data sources
/// And as a source for TestData getters - see test/test_data.dart
class MockDTO {
  const MockDTO._();

  /// Settings

  static final notificationPreferences = NotificationPreferencesDTO(
    [
      NotificationPreferencesGroupDTO(
        'News Updates',
        [
          NotificationChannelDTO(
            'daily_brief',
            'New Daily Brief',
            false,
            true,
          ),
          NotificationChannelDTO(
            'new_topic',
            'Incoming New Topic',
            true,
            true,
          ),
        ],
      ),
      NotificationPreferencesGroupDTO(
        'Product Updates',
        [
          NotificationChannelDTO(
            'new_features',
            'New features & improvements',
            false,
            true,
          ),
        ],
      ),
    ],
  );

  /// Today's topics

  static final currentBrief = CurrentBriefDTO(
    'brief-id',
    // greeting
    HeadlineDTO('**👋 Moritz**, here are the topics of the day', null, null),
    // goodbye
    HeadlineDTO('You’re all _informed_', 'Can\'t get enough?', null),
    [
      topic,
      topicWithEditorOwner,
      topicWithUnknownOwner,
    ],
    3,
  );

  /// Explore

  static final exploreContent = ExploreContentDTO(
    [
      _exploreFeaturedArticlesArea,
      _exploreTopicsArea,
      _exploreTopicsArea2,
    ],
  );

  /// Topics

  static final topic = TopicDTO(
    'topic-id',
    'topic-slug',
    // title, max length is 45 chars
    'Lorem ipsum **dolor sit** amet, consectetur adip',
    // strippedTitle, max length is 45 chars
    'Lorem ipsum dolor sit amet, consectetur adip',
    // introduction
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'url',
    _expert,
    '2021-12-23T11:38:26Z',
    // highlightedPublishers
    [
      _publisher,
      _publisher,
    ],
    // heroImage
    _image,
    // coverImage
    _cover,
    ReadingListDTO(
      'reading-list-id',
      [
        _premiumArticleEntry,
        _freeArticleEntry,
        _freeArticleEntry,
      ],
    ),
    [
      _summaryCardLong,
      _summaryCardShort,
    ],
  );

  static final topicWithEditorOwner = topic.copyWith(
    slug: 'topic-with-editor-owner',
    owner: _editor,
  );

  static final topicWithUnknownOwner = topic.copyWith(
    slug: 'topic-with-unknown-owner',
    owner: TopicOwnerDTO.unknown(),
  );

  /// Articles

  static final premiumArticle = ArticleDTO(
    'id-premium',
    'slug-premium',
    'url',
    // title
    "Denmark's role in the NSA spying scandal",
    // strippedTitle
    "Denmark's role in the NSA spying scandal",
    // credits
    'This article originally appeared here',
    'PREMIUM',
    '2021-12-03',
    // timeToRead
    10,
    _publisher,
    _image,
    articleContentMarkdown,
    'source-url',
    // author
    'Cassandre Lueilwitz',
    false,
  );

  static final articleContentMarkdown = ArticleContentDTO(
    'Novak Djokovic is no doubt spending his time detained in an immigration hotel in Melbourne doing yoga and tai chi, stretching, meditating and adhering to every facet of the strict training regimen that has helped him become the world\'s No. 1 tennis player.\r\n\r\nOn the streets below, Serbian supporters are staging a candlelight vigil and serenading him amid visa-limbo while lawyers fight a deportation order that would deny Djokovic the chance to compete for a 10th Australian Open title and, with it, a men\'s-record 21st Grand Slam title.\r\n\r\nFrom abroad, Serbian President Aleksandar Vucic has decried what he called a "political witch hunt" conducted against his country\'s revered native son. Djokovic\'s father, Srdjan, meantime, told Serbian supporters that Australia was crucifying his son, saying: "Jesus was crucified on the cross . . . but he is still alive among us. They are trying to crucify and belittle Novak and throw him to his knees."\r\n\r\nUntil Monday, when a federal court is expected to end the diplomatic incident that has taken on circuslike theatrics, Djokovic must remain in the hotel.\r\n\r\nYet if his career has proved anything, it is that Djokovic\'s determination to chart his own course - at least in terms of his physical training and mental preparation - is the essence of his dominance in tennis.\r\n\r\nAnd if allowed to enter the country to contest the Australian Open, he may turn this politically charged period in exile - which he could have avoided by following the vaccine mandate that applies to all players, officials and fans at this year\'s tournament - into a yet another "go-against-the grain" triumph.\\r\\nMonday\'s hearing will be held one week before the tournament\'s Jan. 17 start.\r\n\r\nDjokovic was detained at Melbourne\'s airport overnight Wednesday as Australian border officials reviewed his visa and qualifications for a medical exemption to Australia\'s strict covid vaccination requirements.\r\n\r\nHe was one of "a handful" among 26 applicants granted an exemption by Tennis Australia and the government of the state of Victoria to compete in the tournament.\r\n\r\nThe rationale for Djokovic\'s exemption, which was granted in consultation by medical authorities who reviewed applicants without knowing their identity, was a previous covid infection, the Guardian reported.\r\n\r\nBut Australia\'s national standard for medical proof that a visitor to the country cannot be vaccinated, which is enforced at the border, is higher.\r\n\r\nDjokovic has acknowledged contracting covid in summer 2020, after taking part in a short-lived exhibition he staged in Serbia and Croatia amid minimal precautions. It is unclear if he contracted covid more recently.\r\n\r\nWith 20 Grand Slams and the men\'s record-holder for weeks atop the world ranking, Djokovic, 34, is quite possibly the greatest to ever play tennis.\r\n\r\nTwo qualities in particular set the 6-2, 170-pound Djokovic apart: A fanatical adherence to a strict gluten-free diet and a program of stretching and exercise that has transformed his otherwise unremarkable physique (much like Tom Brady) into a purpose-built, pliable winning machine.\r\n\r\nAnd profound self-belief and self-determination that have pulled him from the brink of defeat in countless high-stakes matches. Djokovic\'s inner belief is arguably his greatest asset, but it doesn\'t necessarily mesh with decision-making for the greater good - such as complying with vaccine mandates amid a global pandemic.\r\n\r\nAs a tennis player, Djokovic has no discernible weakness. He has forged himself, over years of training, into an uncommonly complete player. His defense is as much a weapon as his offense. His return of serve is without peer, complemented by a highly effective serve.\r\n\r\nWith the foot speed, reach and flexibility to blast winners even if badly out of position, he covers virtually every inch of the court, sapping opponents\' will in the process.\r\n\r\nAnd he has mastered the mental game, whether that means summoning his best when most players would be at their breaking point or breaking the momentum of unfavorable spells with a bathroom break or call for a trainer.\r\n\r\nNone of these attributes was bestowed. They are not gifts, but the product of relentless work.\\r\\nDjokovic has been chasing tennis perfection since childhood - the past two decades, in the form of Roger Federer and Rafael Nadal, champions who are elder by five-plus years, in the case of Federer, and 11 months, in the case of Nadal.\r\n\r\nFederer had won 16 Grand Slam singles titles, and Nadal had won nine by the time Djokovic claimed his second (at the 2011 Australian Open). But over the decade since, Djokovic has closed the gap with breathtaking efficiency, winning eight of the 13 majors contested since July 2018, to make it a three-way tie for a men\'s record 20 major titles.\r\n\r\nBut Djokovic has yet to close the gap in fans\' affection. He has been forever a third wheel in the sport\'s love affair with Federer and Nadal.\r\n\r\nIn his early career, Djokovic made himself difficult for many to cheer, outside of his devoted following in the Balkans. His tactics smacked of gamesmanship, at times. And he got off on a bad foot with the highly partisan crowd at the U.S. Open, chiding them for not showing due respect.\r\n\r\nYet last September, amid the most gutting defeat of his career - as his pursuit of the rare calendar-year Grand Slam was scuttled by a straight-sets loss to Daniil Medvedev in the U.S. Open final - Djokovic wept with a pathos that won hearts.\r\n\r\nAfterward, he spoke unabashedly about what it meant to feel the crowd\'s embrace. "I felt something I never felt in my life here in New York," Djokovic said. "I did not expect anything. But the amount of support and energy and love I got from the crowd was something that I\'ll remember forever. I mean, that\'s the reason on the changeover I just teared up. The emotion, the energy was so strong. I mean, it\'s as strong as winning 21 Grand Slams. That\'s how I felt, honestly. I felt very, very special."\r\n\r\nIf Djokovic\'s deportation is overturned Monday, he will enter the Australian Open as the tournament\'s nine-time and defending champion, the world No. 1 and a heavy favorite. But he will face significant unknowns, starting with his opening match.\r\n\r\nHow will he be received by fans at Melbourne Park, given the national outcry that erupted when he posted the news Tuesday that he had been granted a medical exemption to the tournament\'s vaccine requirement? Will the inevitable boos shouted by some be drowned out by the vociferous cheers of his Serbian supporters? If the crowd is split, can Djokovic still perform at his best?\r\n\r\nAsked after his victory in the 2021 Australian Open how it felt to be criticized so often, Djokovic said: "Of course it hurts. I\'m a human being like yourself, like anybody else. I have emotions. I don\'t enjoy when somebody attacks me in the media openly and stuff. . . . But I think I\'ve developed a thick skin over the years to just dodge those things and focus on what matters to me the most."',
    'MARKDOWN',
  );

  /// Bookmarks

  static final bookmarkList = BookmarkListDTO(
    [
      BookmarkDTO(
        '0000',
        BookmarkDataDTO.article(MockDTO.premiumArticle),
      ),
      BookmarkDTO(
        '0000',
        BookmarkDataDTO.topic(MockDTO.topic),
      ),
    ],
  );

  static final audioFile = AudioFileDTO(
    'audio-file-url',
  );

  /// Internal

  static final _expert = TopicOwnerDTO.expert(
    'expert-id',
    // name
    '@billgates',
    // bio
    "Hi, it's Bill Gates!If you don't know me... look outside... Windows!\\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.",
    // areaOfExpertise
    'Global Warming',
    'instagram.com',
    'linkedin.com',
    // avatar
    ImageDTO('owner_1'),
  );

  static final _editor = TopicOwnerDTO.editor(
    'editor-id',
    // name
    'Editor',
    // bio
    "Hi, it's Editor!\\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.",
    // avatar
    ImageDTO('owner_1'),
  );

  static final _exploreFeaturedArticlesArea = ExploreContentAreaDTO.articlesWithFeature(
    'explore-articles-id',
    'Premium Articles',
    '#E4F1E2',
    [
      premiumArticle,
      premiumArticle,
      premiumArticle,
      premiumArticle,
      premiumArticle,
    ],
  );

  static final _exploreTopicsArea = ExploreContentAreaDTO.topics(
    'explore-topics-id',
    'Hot topics',
    [
      topic,
      topic,
      topic,
      topic,
      topic,
    ],
  );

  static final _exploreTopicsArea2 = ExploreContentAreaDTO.topics(
    'explore-topics-2-id',
    'By our experts',
    [
      topic,
      topic,
      topic,
      topic,
      topic,
    ],
  );

  static final _premiumArticleEntry = EntryDTO(
    _premiumMediaItemArticle,
    // note
    'Germany is seeking to break a surge in coronavirus infections; India detects two cases of new Omicron variant in Karnataka; Greece and Finland detect first Omicron cases.',
    EntryStyleDTO('#F2E8E7', EntryStyleType.articleCoverWithBigImage),
  );

  static final _freeArticleEntry = EntryDTO(
    _freeMediaItemArticle,
    // note
    'Germany is seeking to break a surge in coronavirus infections; India detects two cases of new Omicron variant in Karnataka; Greece and Finland detect first Omicron cases.',
    EntryStyleDTO('#F2E8E7', EntryStyleType.articleCoverWithoutImage),
  );

  static final _premiumMediaItemArticle = MediaItemDTO.article(
    'id-premium',
    'slug-premium',
    'url',
    // title
    "Denmark's role in the NSA spying scandal",
    // strippedTitle
    "Denmark's role in the NSA spying scandal",
    // credits
    'This article originally appeared here',
    'PREMIUM',
    '2021-12-03',
    // timeToRead
    10,
    _publisher,
    _image,
    'source-url',
    // author
    'Cassandre Lueilwitz',
    false,
  );

  static final _freeMediaItemArticle = MediaItemDTO.article(
    'id-free',
    'slug-free',
    'url',
    // title
    'NSA files: Decoded',
    // strippedTitle
    'NSA files: Decoded',
    // credits
    'This article originally appeared here',
    'FREE',
    '2021-12-03',
    // timeToRead
    10,
    _publisher,
    _image,
    'source-url',
    // author
    'Cassandre Lueilwitz',
    false,
  );

  static final _publisher = PublisherDTO(
    'New York Times',
    ImageDTO('publishers/nyt-black'),
    ImageDTO('publishers/nyt-white'),
  );

  static final _image = ImageDTO('topics/pizza');

  static final _cover = ImageDTO('covers/Cover_5');

  static final _summaryCardLong = SummaryCardDTO(
    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.',
  );

  static final _summaryCardShort = SummaryCardDTO(
    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula.',
  );
}

extension on TopicDTO {
  TopicDTO copyWith({
    String? id,
    String? slug,
    String? title,
    String? strippedTitle,
    String? introduction,
    String? url,
    TopicOwnerDTO? owner,
    String? lastUpdatedAt,
    List<PublisherDTO>? highlightedPublishers,
    ImageDTO? heroImage,
    ImageDTO? coverImage,
    ReadingListDTO? readingList,
    List<SummaryCardDTO>? summaryCards,
  }) {
    return TopicDTO(
      id ?? this.id,
      slug ?? this.slug,
      title ?? this.title,
      strippedTitle ?? this.strippedTitle,
      introduction ?? this.introduction,
      url ?? this.url,
      owner ?? this.owner,
      lastUpdatedAt ?? this.lastUpdatedAt,
      highlightedPublishers ?? this.highlightedPublishers,
      heroImage ?? this.heroImage,
      coverImage ?? this.coverImage,
      readingList ?? this.readingList,
      summaryCards ?? this.summaryCards,
    );
  }
}
