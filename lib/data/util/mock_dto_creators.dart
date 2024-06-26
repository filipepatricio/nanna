import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_text_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_content_type_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_type_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/topic_media_items_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/update_article_progress_response_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_data_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_dto.dt.dart';
import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_list_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/categories_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_item_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_with_items_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/curator_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_style_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_introduction_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_past_day_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_section_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_subsection_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/call_to_action_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_style_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/headline_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/relax_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_area_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_dto.dt.dart';
import 'package:better_informed_mobile/data/explore/api/dto/explore_content_pill_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/legal_page/dto/legal_page_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dt.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_dto.dt.dart';
import 'package:better_informed_mobile/data/release_notes/dto/release_note_media_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_content_dto.dt.dart';
import 'package:better_informed_mobile/data/search/api/dto/search_result_dto.dt.dart';
import 'package:better_informed_mobile/data/subscription/api/dto/active_subscription_dto.dart';
import 'package:better_informed_mobile/data/subscription/api/dto/offering_dto.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_preview_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_publisher_information_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/category_preference_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const _mockedPillIcon = '''
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="2.04297" y="4.60938" width="2.42259" height="19.5556" rx="1.21129" transform="rotate(-15 2.04297 4.60938)" stroke="#252525" stroke-width="1.5"/>
    <path d="M10.8841 4.1995C7.88347 3.30431 5.98922 4.82088 4.87387 5.80993L7.17454 14.3962C8.19918 13.3547 10.3341 11.5914 13.1847 12.7857C16.7053 14.2607 19.3675 11.8193 19.3675 11.8193L16.0664 8.04753L16.8943 2.58907C16.8943 2.58907 14.3331 5.22847 10.8841 4.1995Z" fill="#F3E5F4"/>
    <path d="M4.87387 5.80993L4.37627 5.24878C4.16372 5.43725 4.0759 5.72964 4.14942 6.00404L4.87387 5.80993ZM10.8841 4.1995L11.0985 3.4808L11.0985 3.4808L10.8841 4.1995ZM16.8943 2.58907L17.6358 2.70153C17.6847 2.37913 17.5197 2.06207 17.2275 1.91718C16.9354 1.77228 16.5831 1.83275 16.356 2.06677L16.8943 2.58907ZM16.0664 8.04753L15.3249 7.93506C15.2918 8.15342 15.3566 8.37528 15.502 8.54147L16.0664 8.04753ZM19.3675 11.8193L19.8744 12.372C20.1747 12.0966 20.2002 11.6319 19.9319 11.3253L19.3675 11.8193ZM13.1847 12.7857L13.4746 12.094L13.1847 12.7857ZM7.17454 14.3962L6.4501 14.5903C6.51973 14.8501 6.72322 15.0528 6.98337 15.1214C7.24352 15.19 7.52048 15.1139 7.70916 14.9222L7.17454 14.3962ZM5.37147 6.37108C6.44763 5.41679 8.06639 4.14154 10.6697 4.9182L11.0985 3.4808C7.70055 2.46707 5.53081 4.22498 4.37627 5.24878L5.37147 6.37108ZM10.6697 4.9182C12.6292 5.5028 14.3315 5.03923 15.5157 4.45209C16.1075 4.15865 16.5791 3.8305 16.904 3.57478C17.067 3.44652 17.1946 3.33533 17.2835 3.25409C17.3279 3.21343 17.3629 3.18016 17.3878 3.15588C17.4003 3.14373 17.4103 3.13381 17.4178 3.12633C17.4215 3.12259 17.4246 3.11946 17.4271 3.11695C17.4283 3.1157 17.4294 3.11461 17.4303 3.11368C17.4307 3.11321 17.4311 3.11278 17.4315 3.1124C17.4317 3.11221 17.432 3.11195 17.432 3.11185C17.4323 3.1116 17.4325 3.11136 16.8943 2.58907C16.356 2.06677 16.3562 2.06655 16.3564 2.06635C16.3565 2.06629 16.3567 2.06609 16.3568 2.06598C16.357 2.06575 16.3572 2.06557 16.3574 2.06542C16.3576 2.06513 16.3578 2.06499 16.3578 2.065C16.3577 2.06503 16.3571 2.06566 16.3559 2.06688C16.3535 2.06933 16.3486 2.07411 16.3415 2.08104C16.3273 2.09491 16.3038 2.11735 16.2715 2.14685C16.2069 2.20593 16.1074 2.29291 15.9764 2.39601C15.7133 2.60302 15.329 2.87041 14.8494 3.10821C13.8907 3.58352 12.588 3.92517 11.0985 3.4808L10.6697 4.9182ZM16.1528 2.4766L15.3249 7.93506L16.8079 8.15999L17.6358 2.70153L16.1528 2.4766ZM15.502 8.54147L18.8031 12.3132L19.9319 11.3253L16.6308 7.55358L15.502 8.54147ZM19.3675 11.8193C18.8606 11.2665 18.8608 11.2663 18.8611 11.2661C18.8611 11.266 18.8614 11.2658 18.8615 11.2657C18.8618 11.2654 18.862 11.2652 18.8622 11.265C18.8626 11.2647 18.8628 11.2645 18.8628 11.2644C18.863 11.2643 18.8625 11.2648 18.8614 11.2657C18.8592 11.2677 18.8545 11.2718 18.8475 11.2779C18.8334 11.29 18.8098 11.3099 18.7771 11.3361C18.7116 11.3886 18.6103 11.4659 18.4766 11.5563C18.2082 11.7376 17.8157 11.9673 17.3267 12.1558C16.3557 12.5299 15.0157 12.7396 13.4746 12.094L12.8949 13.4775C14.8744 14.3068 16.6257 14.0333 17.866 13.5555C18.4826 13.3179 18.9757 13.0294 19.3165 12.7991C19.4874 12.6836 19.6215 12.5817 19.7154 12.5064C19.7624 12.4688 19.7994 12.4377 19.826 12.4148C19.8393 12.4033 19.85 12.3939 19.8581 12.3867C19.8622 12.3831 19.8655 12.3801 19.8683 12.3776C19.8696 12.3764 19.8708 12.3753 19.8718 12.3744C19.8724 12.3739 19.8728 12.3735 19.8733 12.3731C19.8735 12.3729 19.8738 12.3726 19.8739 12.3725C19.8741 12.3723 19.8744 12.372 19.3675 11.8193ZM13.4746 12.094C10.1569 10.704 7.69256 12.8003 6.63992 13.8702L7.70916 14.9222C8.70579 13.9092 10.5112 12.4788 12.8949 13.4775L13.4746 12.094ZM4.14942 6.00404L6.4501 14.5903L7.89899 14.202L5.59831 5.61581L4.14942 6.00404Z" fill="#252525"/>
  </svg>
''';

/// To be use as a response for mock implementations of remote data sources
/// And as a source for TestData getters - see test/test_data.dart
class MockDTO {
  const MockDTO._();

  /// Release notes
  ///
  static final noMediaReleaseNote = ReleaseNoteDTO(
    headline: 'Lorem ipsum dolor sit amet, consectetur',
    // max 40 chars
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna ali',
    // max 120 chars
    date: '2022-05-20',
    media: [],
    version: '1.0.0',
  );

  static final singleMediaReleaseNote = ReleaseNoteDTO(
    headline: 'Lorem ipsum dolor sit amet, consectetur',
    // max 40 chars
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna ali',
    // max 120 chars
    date: '2022-05-20',
    media: [
      ReleaseNoteMediaDTO.png('png', 'www.image.com'),
    ],
    version: '1.0.1',
  );

  static final multipleMediaReleaseNote = ReleaseNoteDTO(
    headline: 'Lorem ipsum dolor sit amet, consectetur',
    // max 40 chars
    content:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna ali',
    // max 120 chars
    date: '2022-05-20',
    media: [
      ReleaseNoteMediaDTO.png('png', 'www.image.com'),
      ReleaseNoteMediaDTO.png('png', 'www.image.com'),
      ReleaseNoteMediaDTO.png('png', 'www.image.com'),
    ],
    version: '1.0.2',
  );

  /// Settings

  static final notificationPreferences = NotificationPreferencesDTO(
    [
      NotificationPreferencesGroupDTO(
        'News Updates',
        [
          NotificationChannelDTO(
            'daily_brief',
            'New Daily Brief',
            'Our skilled editorial team reads and selects the most important articles of the day.',
            false,
            true,
          ),
          NotificationChannelDTO(
            'new_topic',
            'Incoming topic',
            'We provide you with incoming updates and new topics on a rolling daily basis.',
            true,
            true,
          ),
          NotificationChannelDTO(
            'new_article',
            'Incoming article',
            'We provide you with incoming updates and new articles on a rolling daily basis.',
            true,
            false,
          ),
        ],
      ),
      NotificationPreferencesGroupDTO(
        'Product Updates',
        [
          NotificationChannelDTO(
            'new_features',
            'New features & improvements',
            'Get the latest on new improvements and features.',
            false,
            true,
          ),
        ],
      ),
    ],
  );

  /// Today's topics
  static BriefDTO currentBrief({DateTime? date}) => BriefDTO(
        'brief-id',
        // unseenCount
        3,
        // greeting
        HeadlineDTO('**👋 Moritz**, here are the topics of the day', null, null),
        // introduction - text max length: 150 chars
        const BriefIntroductionDTO(
          icon: _mockedPillIcon,
          text:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniamaa',
        ),
        (date ?? DateTime(2022, 07, 8)).toIso8601String(),
        relax,
        //sections
        [
          BriefSectionDTO.entries(
            'General News',
            null,
            [
              BriefEntryDTO(
                topic.asBriefEntryItem,
                _briefEntryStyleTopic,
                //isNew
                true,
              ),
              BriefEntryDTO(
                premiumArticleWithAudio.asBriefEntryItem,
                _briefEntryStyleArticleLarge,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNoteWithAudio.asBriefEntryItem,
                _briefEntryStyleArticleLarge,
                //isNew
                true,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNoteWithAudio.asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                _freeArticleWithoutNote.asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                true,
              ),
              BriefEntryDTO(
                _freeArticle.asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              ..._briefEntriesArticlesList,
            ],
          ),
          BriefSectionDTO.subsections(
            'Personalised content',
            null,
            [
              BriefSubsectionDTO(
                title: 'Crypto',
                entries: _briefEntriesArticlesList,
              ),
              BriefSubsectionDTO(
                title: 'Business',
                entries: _briefEntriesArticlesList,
              ),
            ],
          ),
          BriefSectionDTO.entries(
            '_Lighter note_',
            null,
            [
              BriefEntryDTO(
                topicWithUnknownOwner.asBriefEntryItem,
                _briefEntryStyleTopic,
                //isNew
                true,
              ),
              ..._briefEntriesArticlesList,
            ],
          ),
        ],
      );

  static final _briefEntriesArticlesList = [
    BriefEntryDTO(
      premiumArticle.asBriefEntryItem,
      _briefEntryStyleArticleMediumItem,
      //isNew
      false,
    ),
    BriefEntryDTO(
      premiumArticleWithAudio.asBriefEntryItem,
      _briefEntryStyleArticleMediumItem,
      //isNew
      true,
    ),
    BriefEntryDTO(
      _freeArticle.asBriefEntryItem,
      _briefEntryStyleArticleMediumItem,
      //isNew
      false,
    ),
  ];

  static BriefDTO get currentBriefVisited => currentBrief().copyWith(
        sections: [
          BriefSectionDTO.entries(
            'General News',
            null,
            [
              BriefEntryDTO(
                topic.copyWith(visited: true).asBriefEntryItem,
                _briefEntryStyleTopic,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithAudio.copyWith(progressState: ArticleProgressState.finished).asBriefEntryItem,
                _briefEntryStyleArticleLarge,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNoteWithAudio
                    .copyWith(progressState: ArticleProgressState.finished)
                    .asBriefEntryItem,
                _briefEntryStyleArticleLarge,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithAudio.copyWith(progressState: ArticleProgressState.finished).asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNoteWithAudio
                    .copyWith(progressState: ArticleProgressState.finished)
                    .asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithAudio.copyWith(progressState: ArticleProgressState.finished).asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNoteWithAudio
                    .copyWith(progressState: ArticleProgressState.finished)
                    .asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticle.copyWith(progressState: ArticleProgressState.finished).asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
              BriefEntryDTO(
                premiumArticleWithoutNote.copyWith(progressState: ArticleProgressState.finished).asBriefEntryItem,
                _briefEntryStyleArticleMediumItem,
                //isNew
                false,
              ),
            ],
          ),
        ],
      );

  // Past days briefs
  static final pastDaysBriefs = [
    BriefPastDayDTO(
      DateTime(2022, 07, 8).toIso8601String(),
      true,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 1)).toIso8601String(),
      true,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 2)).toIso8601String(),
      false,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 3)).toIso8601String(),
      false,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 4)).toIso8601String(),
      true,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 5)).toIso8601String(),
      true,
    ),
    BriefPastDayDTO(
      DateTime(2022, 07, 8).add(const Duration(days: 6)).toIso8601String(),
      true,
    ),
  ];

  static final _briefEntryStyleTopic = BriefEntryStyleDTO(
    null,
    BriefEntryStyleType.topicCard,
  );
  static final _briefEntryStyleArticleMediumItem = BriefEntryStyleDTO(
    '#F2E8E7',
    BriefEntryStyleType.articleCardMedium,
  );
  static final _briefEntryStyleArticleLarge = BriefEntryStyleDTO(
    null,
    BriefEntryStyleType.articleCardLarge,
  );

  /// Explore
  static final exploreContent = ExploreContentDTO(
    [
      ExploreContentPillDTO.articles('articles', 'Articles', _mockedPillIcon),
      ExploreContentPillDTO.articles('topics', 'Topics', _mockedPillIcon),
      ExploreContentPillDTO.articles('articles', 'Articles', null),
      ExploreContentPillDTO.articles('topics', 'Topics', null),
      ExploreContentPillDTO.articles('articles', 'Articles', _mockedPillIcon),
      ExploreContentPillDTO.articles('topics', 'Topics', _mockedPillIcon),
    ],
    [
      _exploreTopicsArea,
      _exploreArticlesArea,
      _exploreHighlightedTopicsArea,
      _exploreSmallTopicsArea,
      _exploreArticlesListArea,
    ],
  );

  static final exploreContentVisited = ExploreContentDTO(
    [
      ExploreContentPillDTO.articles('articles', 'Articles', _mockedPillIcon),
      ExploreContentPillDTO.articles('topics', 'Topics', _mockedPillIcon),
      ExploreContentPillDTO.articles('articles', 'Articles', null),
      ExploreContentPillDTO.articles('topics', 'Topics', null),
      ExploreContentPillDTO.articles('articles', 'Articles', _mockedPillIcon),
      ExploreContentPillDTO.articles('topics', 'Topics', _mockedPillIcon),
    ],
    [
      _exploreTopicsAreaVisited,
      _exploreArticlesAreaVisited,
      _exploreHighlightedTopicsAreaVisited,
      _exploreSmallTopicsAreaVisited,
      _exploreArticlesListAreaVisited,
    ],
  );

  static final search = SearchContentDTO(
    [
      SearchResultDTO.topic(topicPreview),
      SearchResultDTO.article(_freeArticle),
      SearchResultDTO.article(_freeArticle.copyWith(progressState: ArticleProgressState.finished)),
      SearchResultDTO.topic(topicPreview),
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
    // ownersNote
    'Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'url',
    curationInfoExpert,
    '2021-12-23T11:38:26Z',
    // highlightedPublishers
    _topicPublisherInformation,
    // heroImage
    _image,
    [
      _premiumArticleEntry,
      _premiumArticleWithAudioEntry,
      _freeArticleEntry,
    ],
    '* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do\n'
        '* Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do\n'
        '* Lorem ipsum dolor sit amet, consectetur adipisci  elit, sed do onsectetur adipisci  elit, sed do nsectetur adipisci  elit, sed do',
    false,
    category,
  );

  static final _topicPublisherInformation = TopicPublisherInformationDTO(
    [
      _publisher,
      _publisher,
    ],
    "+ 2 more",
  );

  static final topicWithEditorOwner = topic.copyWith(
    slug: 'topic-with-editor-owner',
    curationInfo: curationInfoEditor,
  );

  static final topicWithUnknownOwner = topic.copyWith(
    slug: 'topic-with-unknown-owner',
    curationInfo: curationInfoUnknown,
  );

  static final topicVisited = topic.copyWith(visited: true);

  static final topicPreview = topic.asPreview;

  static final topicPreviewVisited = topicVisited.asPreview;

  static final topicPreviewWithEditorOwner = topicWithEditorOwner.asPreview;

  static final topicPreviewWithUnknownOwner = topicWithUnknownOwner.asPreview;

  /// Articles

  static final _freeArticleWithoutNote = ArticleHeaderDTO(
    // id
    'id-free',
    // slug
    'slug-free',
    // url
    'url',
    // title
    'Location, Location, Location: Investing in Real Estate in the Metaverse',
    // strippedTitle
    'Location, Location, Location: Investing in Real Estate in the Metaverse',
    // note
    null,
    // isNoteCollapsible
    false,
    // type
    ArticleTypeDTO.free,
    // kind
    _kind,
    // publicationDate
    '2021-12-03',
    // timeToRead
    10,
    // publisher
    _publisher,
    // image
    null,
    // sourceUrl
    'source-url',
    // author
    'Cassandre Lueilwitz',
    // hasAudioVersion
    false,
    // availableInSubscription
    true,
    // progress
    updateArticleProgressResponse.progress,
    // progressState
    ArticleProgressState.unread,
    // locked
    false,
    category,
    curationInfoExpert,
  );

  static final _freeArticle = _freeArticleWithoutNote.copyWith(
    note:
        'You should read this because everything you wanted to know about the hype about virtual real estate, major players and how to get started with virtual real estate platforms.',
    image: _articleImageCloudinary,
  );

  static final premiumArticleWithoutNote = _freeArticleWithoutNote.copyWith(
    id: 'id-premium',
    slug: 'slug-premium',
    type: ArticleTypeDTO.premium,
    image: _articleImageCloudinary,
    locked: true,
  );

  static final premiumArticleWithoutImage = _freeArticleWithoutNote.copyWith(
    id: 'id-premium',
    slug: 'slug-premium',
    type: ArticleTypeDTO.premium,
  );

  static final premiumArticle = _freeArticle.copyWith(
    id: 'id-premium',
    slug: 'slug-premium',
    type: ArticleTypeDTO.premium,
    image: _articleImageCloudinary,
    locked: true,
  );

  static final premiumArticleNoteCollapsible = _freeArticle.copyWith(
    id: 'id-premium-collapsible',
    slug: 'slug-premium-collapsible',
    type: ArticleTypeDTO.premium,
    image: _articleImageCloudinary,
    isNoteCollapsible: true,
    locked: true,
  );

  static final premiumArticleWithoutNoteWithAudio = premiumArticleWithoutNote.copyWith(
    id: 'id-premium-audio',
    slug: 'slug-premium-audio',
    hasAudioVersion: true,
  );
  static final premiumArticleWithAudio = premiumArticle.copyWith(
    id: 'id-premium-audio',
    slug: 'slug-premium-audio',
    hasAudioVersion: true,
    image: _articleImageCloudinary,
  );
  static final premiumArticleWithAudioNoImage = premiumArticleWithoutImage.copyWith(
    id: 'id-premium-audio',
    slug: 'slug-premium-audio',
    hasAudioVersion: true,
  );
  static final premiumArticleWithAudioLocked = premiumArticle.copyWith(
    id: 'id-premium-audio',
    slug: 'slug-premium-audio-not-available',
    hasAudioVersion: true,
    availableInSubscription: false,
    image: _articleImageCloudinary,
  );

  static final articleContentMarkdown = ArticleContentDTO(
    ArticleContentTextDTO(
      '# Novak Djokovic is no doubt _spending his time detained in an immigration hotel_ in Melbourne doing yoga and tai chi, stretching, meditating and adhering to every facet of the strict training regimen that has helped him become the world\'s No. 1 tennis player.\r\n\r\n> On the streets below, Serbian supporters are staging a candlelight vigil and serenading him amid visa-limbo while lawyers fight a deportation order that would deny Djokovic the chance to compete for a 10th Australian Open title and, with it, a men\'s-record 21st Grand Slam title.\r\n\r\nFrom abroad, Serbian President Aleksandar Vucic has decried what he called a "political witch hunt" conducted against his country\'s revered native son. Djokovic\'s father, Srdjan, meantime, told Serbian supporters that Australia was crucifying his son, saying: "Jesus was crucified on the cross . . . but he is still alive among us. They are trying to crucify and belittle Novak and throw him to his knees."\r\n\r\nUntil Monday, when a federal court is expected to end the diplomatic incident that has taken on circuslike theatrics, Djokovic must remain in the hotel.\r\n\r\nYet if his career has proved anything, it is that Djokovic\'s determination to chart his own course - at least in terms of his physical training and mental preparation - is the essence of his dominance in tennis.\r\n\r\n## And if allowed to enter the country to contest the Australian Open, he may turn this politically charged period in exile - which he could have avoided by following the vaccine mandate that applies to all players, officials and fans at this year\'s tournament - into a yet another "go-against-the grain" triumph.\\r\\nMonday\'s hearing will be held one week before the tournament\'s Jan. 17 start.\r\n\r\nDjokovic was detained at Melbourne\'s airport overnight Wednesday as Australian border officials reviewed his visa and qualifications for a medical exemption to Australia\'s strict covid vaccination requirements.\r\n\r\nHe was one of "a handful" among 26 applicants granted an exemption by Tennis Australia and the government of the state of Victoria to compete in the tournament.\r\n\r\nThe rationale for Djokovic\'s exemption, which was granted in consultation by medical authorities who reviewed applicants without knowing their identity, was a previous covid infection, the Guardian reported.\r\n\r\nBut Australia\'s national standard for medical proof that a visitor to the country cannot be vaccinated, which is enforced at the border, is higher.\r\n\r\nDjokovic has acknowledged contracting covid in summer 2020, after taking part in a short-lived exhibition he staged in Serbia and Croatia amid minimal precautions. It is unclear if he contracted covid more recently.\r\n\r\nWith 20 Grand Slams and the men\'s record-holder for weeks atop the world ranking, Djokovic, 34, is quite possibly the greatest to ever play tennis.\r\n\r\nTwo qualities in particular set the 6-2, 170-pound Djokovic apart: A fanatical adherence to a strict gluten-free diet and a program of stretching and exercise that has transformed his otherwise unremarkable physique (much like Tom Brady) into a purpose-built, pliable winning machine.\r\n\r\nAnd profound self-belief and self-determination that have pulled him from the brink of defeat in countless high-stakes matches. Djokovic\'s inner belief is arguably his greatest asset, but it doesn\'t necessarily mesh with decision-making for the greater good - such as complying with vaccine mandates amid a global pandemic.\r\n\r\nAs a tennis player, Djokovic has no discernible weakness. He has forged himself, over years of training, into an uncommonly complete player. His defense is as much a weapon as his offense. His return of serve is without peer, complemented by a highly effective serve.\r\n\r\nWith the foot speed, reach and flexibility to blast winners even if badly out of position, he covers virtually every inch of the court, sapping opponents\' will in the process.\r\n\r\nAnd he has mastered the mental game, whether that means summoning his best when most players would be at their breaking point or breaking the momentum of unfavorable spells with a bathroom break or call for a trainer.\r\n\r\nNone of these attributes was bestowed. They are not gifts, but the product of relentless work.\\r\\nDjokovic has been chasing tennis perfection since childhood - the past two decades, in the form of Roger Federer and Rafael Nadal, champions who are elder by five-plus years, in the case of Federer, and 11 months, in the case of Nadal.\r\n\r\nFederer had won 16 Grand Slam singles titles, and Nadal had won nine by the time Djokovic claimed his second (at the 2011 Australian Open). But over the decade since, Djokovic has closed the gap with breathtaking efficiency, winning eight of the 13 majors contested since July 2018, to make it a three-way tie for a men\'s record 20 major titles.\r\n\r\nBut Djokovic has yet to close the gap in fans\' affection. He has been forever a third wheel in the sport\'s love affair with Federer and Nadal.\r\n\r\nIn his early career, Djokovic made himself difficult for many to cheer, outside of his devoted following in the Balkans. His tactics smacked of gamesmanship, at times. And he got off on a bad foot with the highly partisan crowd at the U.S. Open, chiding them for not showing due respect.\r\n\r\nYet last September, amid the most gutting defeat of his career - as his pursuit of the rare calendar-year Grand Slam was scuttled by a straight-sets loss to Daniil Medvedev in the U.S. Open final - Djokovic wept with a pathos that won hearts.\r\n\r\nAfterward, he spoke unabashedly about what it meant to feel the crowd\'s embrace. "I felt something I never felt in my life here in New York," Djokovic said. "I did not expect anything. But the amount of support and energy and love I got from the crowd was something that I\'ll remember forever. I mean, that\'s the reason on the changeover I just teared up. The emotion, the energy was so strong. I mean, it\'s as strong as winning 21 Grand Slams. That\'s how I felt, honestly. I felt very, very special."\r\n\r\nIf Djokovic\'s deportation is overturned Monday, he will enter the Australian Open as the tournament\'s nine-time and defending champion, the world No. 1 and a heavy favorite. But he will face significant unknowns, starting with his opening match.\r\n\r\nHow will he be received by fans at Melbourne Park, given the national outcry that erupted when he posted the news Tuesday that he had been granted a medical exemption to the tournament\'s vaccine requirement? Will the inevitable boos shouted by some be drowned out by the vociferous cheers of his Serbian supporters? If the crowd is split, can Djokovic still perform at his best?\r\n\r\nAsked after his victory in the 2021 Australian Open how it felt to be criticized so often, Djokovic said: "Of course it hurts. I\'m a human being like yourself, like anybody else. I have emotions. I don\'t enjoy when somebody attacks me in the media openly and stuff. . . . But I think I\'ve developed a thick skin over the years to just dodge those things and focus on what matters to me the most."',
      ArticleContentTypeDTO.markdown,
    ),
    // credits
    'This article originally appeared here',
  );

  static final articleContentMarkdownLocked = ArticleContentDTO(
    ArticleContentTextDTO(
      '# Novak Djokovic is no doubt _spending his time detained in an immigration hotel_ in Melbourne doing yoga and tai chi, stretching, meditating and adhering to every facet of the strict training regimen that has helped him become the world\'s No. 1 tennis player.\r\n\r\n> On the streets below, Serbian supporters are staging a candlelight vigil and serenading him amid visa-limbo while lawyers fight a deportation order that would deny Djokovic the chance to compete for a 10th Australian Open title and, with it, a men\'s-record 21st Grand Slam title."',
      ArticleContentTypeDTO.markdown,
    ),
    // credits
    'This article originally appeared here',
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
      BookmarkDTO(
        '0001',
        BookmarkDataDTO.article(MockDTO.premiumArticleWithoutImage),
      ),
    ],
  );

  static final audioFile = AudioFileDTO(
    'audio-file-url',
    'Created by informed under the license of the Financial Times.',
  );

  // CategoryDTO
  static const category = CategoryDTO(
    name: 'Politics',
    id: 'id-politics',
    slug: 'politics',
    icon: _mockedPillIcon,
    color: '#E3BEE9',
  );

  static const category2 = CategoryDTO(
    name: 'Tech',
    id: 'id-tech',
    slug: 'tech',
    icon: _mockedPillIcon,
    color: '#F2E8E7',
  );

  static const category3 = CategoryDTO(
    name: 'Politics 2',
    id: 'id-politics-2',
    slug: 'politics-2',
    icon: _mockedPillIcon,
    color: '#E3BEE9',
  );

  static const category4 = CategoryDTO(
    name: 'Tech 2',
    id: 'id-tech-2',
    slug: 'tech-2',
    icon: _mockedPillIcon,
    color: '#F2E8E7',
  );

  static final categoryWithItems = CategoryWithItemsDTO(
    name: 'Politics',
    id: 'id',
    slug: 'politics',
    icon: _mockedPillIcon,
    color: '#E3BEE9',
    items: categoryItemList,
  );

  static final categoryItemList = [
    CategoryItemDTO.topic(topicPreview),
    CategoryItemDTO.article(_freeArticle),
    CategoryItemDTO.article(_freeArticle.copyWith(progressState: ArticleProgressState.finished)),
    CategoryItemDTO.topic(topicPreview),
  ];

  static final curationInfoExpert = CurationInfoDTO(
    "Recommended by",
    _expert,
  );

  static final curationInfoEditor = CurationInfoDTO(
    "Recommended by",
    _editor,
  );

  static final curationInfoEditorialTeam = CurationInfoDTO(
    "Recommended by",
    _editorialTeam,
  );

  static final curationInfoUnknown = CurationInfoDTO(
    "Recommended by",
    CuratorDTO.unknown(),
  );

  // CategoriesDTO

  static const categories = CategoriesDTO(
    [
      MockDTO.category,
      MockDTO.category2,
      MockDTO.category3,
      MockDTO.category4,
      MockDTO.category,
      MockDTO.category2,
      MockDTO.category3,
      MockDTO.category4,
    ],
  );

  // CategoryPreference

  static const categoryPreferenceFollowing = CategoryPreferenceDTO(
    isPreferred: true,
    category: MockDTO.category,
  );

  static const categoryPreference = CategoryPreferenceDTO(
    isPreferred: false,
    category: MockDTO.category2,
  );

  // CategoryPreferencesResponseDTO

  static final categoryPreferences = <CategoryPreferenceDTO>[
    MockDTO.categoryPreferenceFollowing,
    MockDTO.categoryPreference,
  ];

  static final otherTopicEntries = TopicMediaItemsDTO(
    [
      premiumArticle.asMediaItem,
      premiumArticleWithAudio.asMediaItem,
      _freeArticle.asMediaItem,
    ],
  );

  static final user = UserDTO('1', 'User', 'Test', 'test@betterinformed.io');

  /// Internal

  static final _expert = CuratorDTO.expert(
    'expert-id',
    // name
    '@billgates',
    // bio
    "Hi, it's Bill Gates!If you don't know me... look outside... Windows!\\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.",
    // areaOfExpertise
    'Global Warming',
    'instagram.com',
    'linkedin.com',
    'website.com',
    'twitter.com',
    // avatar
    ImageDTO('owner_1'),
  );

  static final _editor = CuratorDTO.editor(
    'editor-id',
    // name
    'Editor',
    // bio
    "Hi, it's Editor!\\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.",
    // avatar
    ImageDTO('owner_1'),
  );

  static final _editorialTeam = CuratorDTO.editorialTeam(
    'informed',
    "Hi, it's informed!\\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu.",
  );

  static final _exploreArticlesArea = ExploreContentAreaDTO.articles(
    'explore-articles-id',
    'By Publisher',
    'This is description',
    _mockedPillIcon,
    null,
    false,
    true,
    [
      premiumArticle,
      _freeArticle,
      premiumArticle,
      _freeArticle,
      premiumArticle,
    ],
  );

  static final _exploreArticlesAreaVisited = ExploreContentAreaDTO.articles(
    'explore-articles-id',
    'By Publisher',
    'This is description',
    _mockedPillIcon,
    null,
    false,
    true,
    [
      premiumArticle.copyWith(progressState: ArticleProgressState.finished),
      _freeArticle.copyWith(progressState: ArticleProgressState.inProgress),
      premiumArticle.copyWith(progressState: ArticleProgressState.inProgress),
      _freeArticle.copyWith(progressState: ArticleProgressState.finished),
      premiumArticle.copyWith(progressState: ArticleProgressState.finished),
    ],
  );

  static final _exploreTopicsArea = ExploreContentAreaDTO.topics(
    'explore-topics-id',
    'Hot topics',
    _mockedPillIcon,
    null,
    false,
    true,
    [
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
    ],
  );

  static final _exploreTopicsAreaVisited = ExploreContentAreaDTO.topics(
    'explore-topics-id',
    'Hot topics',
    _mockedPillIcon,
    null,
    false,
    true,
    [
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
    ],
  );

  static final _exploreHighlightedTopicsArea = ExploreContentAreaDTO.highlightedTopics(
    'explore-highlighted-topics-id',
    'Trending news',
    'Discover other topics of interest',
    '#DFBFFF',
    _mockedPillIcon,
    false,
    false,
    [
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
    ],
  );

  static final _exploreHighlightedTopicsAreaVisited = ExploreContentAreaDTO.highlightedTopics(
    'explore-highlighted-topics-id',
    'Trending news',
    'Discover other topics of interest',
    '#DFBFFF',
    _mockedPillIcon,
    false,
    false,
    [
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
    ],
  );

  static final _exploreSmallTopicsArea = ExploreContentAreaDTO.smallTopics(
    'explore-small-topics-id',
    'More topics',
    'Discover other topics of interest',
    null,
    _mockedPillIcon,
    false,
    false,
    [
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
      topicPreview,
    ],
  );

  static final _exploreSmallTopicsAreaVisited = ExploreContentAreaDTO.smallTopics(
    'explore-small-topics-id',
    'More topics',
    'Discover other topics of interest',
    null,
    _mockedPillIcon,
    false,
    false,
    [
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
      topicPreviewVisited,
    ],
  );

  static final _exploreArticlesListArea = ExploreContentAreaDTO.articlesList(
    'explore-articles-list-id',
    'Some more articles',
    'Those are articles in the list',
    _mockedPillIcon,
    null,
    false,
    false,
    [
      premiumArticle,
      _freeArticle,
      premiumArticle,
      _freeArticle,
      premiumArticle,
    ],
  );

  static final _exploreArticlesListAreaVisited = ExploreContentAreaDTO.articlesList(
    'explore-articles-list-id',
    'Some more articles',
    'Those are articles in the list',
    _mockedPillIcon,
    null,
    false,
    false,
    [
      premiumArticle.copyWith(progressState: ArticleProgressState.inProgress),
      _freeArticle.copyWith(progressState: ArticleProgressState.inProgress),
      premiumArticle.copyWith(progressState: ArticleProgressState.finished),
      _freeArticle.copyWith(progressState: ArticleProgressState.finished),
      premiumArticle.copyWith(progressState: ArticleProgressState.inProgress),
    ],
  );

  static final _premiumArticleEntry = EntryDTO(
    premiumArticle.asMediaItem,
    // note
    'You should read this because everything you wanted to know about the hype about virtual real estate, major players and how to get started with virtual real estate platforms.',
    EntryStyleDTO('#F2E8E7', EntryStyleType.articleCoverWithBigImage),
  );

  static final _premiumArticleWithAudioEntry = EntryDTO(
    premiumArticleWithAudio.asMediaItem,
    // note
    'You should read this because everything you wanted to know about the hype about virtual real estate, major players and how to get started with virtual real estate platforms.',
    EntryStyleDTO('#F2E8E7', EntryStyleType.articleCoverWithBigImage),
  );

  static final _freeArticleEntry = EntryDTO(
    _freeArticle.asMediaItem,
    // note
    'You should read this because everything you wanted to know about the hype about virtual real estate, major players and how to get started with virtual real estate platforms.',
    EntryStyleDTO('#F2E8E7', EntryStyleType.articleCoverWithoutImage),
  );

  static final _kind = ArticleKindDTO(
    'Opinion',
  );

  static final updateArticleProgressResponse = UpdateArticleProgressResponseDTO(
    ArticleProgressDTO(
      // audioPosition
      30,
      // audioProgress
      45,
      // contentProgress
      10,
    ),
    ArticleProgressState.inProgress,
    null,
  );

  static final updateArticleProgressResponseWarning = UpdateArticleProgressResponseDTO(
    ArticleProgressDTO(
      // audioPosition
      30,
      // audioProgress
      45,
      // contentProgress
      10,
    ),
    ArticleProgressState.inProgress,
    'This is your last free article this month.',
  );

  static final _publisher = PublisherDTO(
    'Manhattan Center for Cognitive Behavioral Therapy',
    ImageDTO('publishers/nyt-black'),
    ImageDTO('publishers/nyt-white'),
  );

  static final _image = ImageDTO('topics/pizza');

  static final _articleImageCloudinary = ArticleImageDTO.cloudinary('topics/pizza');

  static final relax = RelaxDTO('0/24 articles read', _mockedPillIcon, callToAction, 'Time to get _informed_');

  static final callToAction = CallToActionDTO('More stories on', 'Explore');

  static final activeSubscription = activeSubscriptionWithCustomer(customerInfo);

  static final activeSubscriptionManual = activeSubscriptionWithCustomer(customerInfoManual);

  static final activeSubscriptionTrial = activeSubscriptionWithCustomer(customerInfoTrial);

  static const offeringWithTrial = OfferingDTO(
    offering: Offering(
      'offering-id-trial',
      'description',
      [annualPackage, monthlyPackage],
    ),
    isFirstTimeSubscriber: true,
  );

  static const offeringWithoutTrial = OfferingDTO(
    offering: Offering(
      'offering-id',
      'description',
      [annualPackage, monthlyPackage],
    ),
    isFirstTimeSubscriber: false,
  );

  static const annualPackage = Package(
    '\$rc_annual', //identifier
    PackageType.annual, //packageType
    //storeProduct
    StoreProduct(
      'inf_st_0099_1y_2w0', //identifier
      'with 14 days free trial', //description
      'Yearly subscription', //title
      0.99, //price
      '\$0.99', //priceString
      'USD', //currencyCode
      introductoryPrice: IntroductoryPrice(
        0.0, //price
        '', //priceString
        '', //period
        0, //cycles
        PeriodUnit.week, //periodUnit
        2, //periodNumberOfUnits
      ),
      discounts: [],
    ),
    'premium', //offeringIdentifier
  );

  static const monthlyPackage = Package(
    '\$rc_monthly',
    PackageType.monthly,
    StoreProduct(
      'inf_st_0049_1m_1w0',
      'with 7 days free trial',
      'Monthly subscription',
      0.49000000000000005,
      '\$0.49',
      'USD',
      introductoryPrice: IntroductoryPrice(
        0.0, //price
        '', //priceString
        '', //period
        0, //cycles
        PeriodUnit.week, //periodUnit
        1,
      ),
      discounts: [],
    ),
    'premium',
  );

  static final annualSubscriptionPlan = SubscriptionPlan(
    type: SubscriptionPlanType.annual,
    title: annualPackage.storeProduct.title,
    description: annualPackage.storeProduct.description,
    price: annualPackage.storeProduct.price,
    priceString: annualPackage.storeProduct.priceString,
    monthlyPrice: annualPackage.storeProduct.price / 12.0,
    monthlyPriceString: '\$${(annualPackage.storeProduct.price / 12.0).toStringAsFixed(2)}',
    trialDays: 14,
    reminderDays: 7,
    offeringId: offeringWithTrial.offering.identifier,
    packageId: annualPackage.identifier,
    productId: annualPackage.storeProduct.identifier,
  );

  static final monthlySubscriptionPlan = SubscriptionPlan(
    type: SubscriptionPlanType.monthly,
    title: monthlyPackage.storeProduct.title,
    description: monthlyPackage.storeProduct.description,
    price: monthlyPackage.storeProduct.price,
    priceString: monthlyPackage.storeProduct.priceString,
    monthlyPrice: monthlyPackage.storeProduct.price,
    monthlyPriceString: monthlyPackage.storeProduct.priceString,
    trialDays: 7,
    reminderDays: 3,
    offeringId: offeringWithTrial.offering.identifier,
    packageId: monthlyPackage.identifier,
    productId: monthlyPackage.storeProduct.identifier,
  );

  static final premiumEntitlement = EntitlementInfo(
    //identifier
    'premium',
    //isActive
    true,
    //willRenew
    true,
    //latestPurchaseDate
    '2022-09-28T15:59:37Z',
    //originalPurchaseDate
    '2022-09-26T18:21:43Z',
    //productIdentifier
    monthlyPackage.storeProduct.identifier,
    //isSandbox
    true,
    ownershipType: OwnershipType.purchased,
    store: Store.appStore,
    periodType: PeriodType.normal,
    expirationDate: '2022-09-28T16:04:37Z',
    unsubscribeDetectedAt: null,
    billingIssueDetectedAt: null,
  );

  static final premiumEntitlementTrial = premiumEntitlement.copyWith(periodType: PeriodType.trial);

  static final customerInfoTrial = customerInfoWithEntitlement(premiumEntitlementTrial);

  static final customerInfo = customerInfoWithEntitlement(premiumEntitlement);

  static final customerInfoManual = customerInfoWithEntitlement(
    premiumEntitlement.copyWith(productIdentifier: 'custom-identifier'),
  );

  static final legalPage = LegalPageDTO(
    title: 'Legal Page',
    content:
        'This privacy policy applies to data processing by mim technologies GmbH ("controller", "we" or "us") when using the Informed App ("App") and when visiting our website "informed.so" ("Website"). \n\nInformed offers users access to journalistic content from selected partners. The scope of the articles and functions contained in the app depends on whether the user uses the app in the free or paid version (the latter: "subscription").\n\nUsing our app and visiting our website involves certain processing of your personal data. Personal data is any information relating to an identified or identifiable natural person, e.g. name, address, email address. We process data that you provide to us independently as well as data that we collect from you when you use the app and visit our website. \n\nWhen processing your personal data, we observe the applicable data protection laws, in particular the European Data Protection Regulation ("DSGVO") and the German Federal Data Protection Act ("BDSG"). \n\nWith this data protection declaration, we would like to inform you about which personal data we process, for what purposes and on what legal basis. \n\n1. Name and contact details of the data protection officer \n    Responsible for the processing of your data is mim technologies GmbH; address: Wallstr. 67, 10179 Berlin; phone: 030 62931793, e-mail: contact@informed.so. \n2. Collection and storage of personal data as well as type and purpose of their processing, relevant legal basis and storage period \n    1. Download the app \n        When you download our app, the information required for the download is transmitted to the app store you accessed, i.e. in particular your user name, email address and customer number of your account, time of download, payment information and the individual device identification number. We have no influence on this data collection and are not responsible for it. We only process the data insofar as it is necessary for downloading the app to your mobile device.\n    2. Use of our app and website \n        When you use our website and our app, we automatically collect and store data that your browser transmits to our server (so-called server log files), whereby logging only takes place to the extent that is technically necessary. \n        \n        The following information is collected: \n        - Operating system and information on the Internet browser used, including installed add-ons;\n        - IP address (internet protocol address) of the end device from which the online offer is accessed;\n        - Internet address of the website from which the online offer was accessed (so-called origin or referrer URL);\n        - Name of the service provider through which the online offer is accessed;\n        - Name of the retrieved files or information;\n        - Date and time as well as duration of the retrieval.\n        The legal basis for the collection of this data is Art. 6 para. 1 p. 1 lit. f) DSGVO. Our legitimate interest in collecting this data follows from the following purposes:\n        - Ensure optimal use of our website and app,\n        - Ensure smooth connection establishment, \n        - Evaluation of system security and stability.\n    3. Creation of an Informed Account\n        1. Sign-in with Apple\n            You have the option of registering in our app via the Apple sign-in function. As an Apple user, this saves you time when registering . When you sign in with your Apple ID, either your email address stored with Apple and/or your name or a one-time email address generated by Apple will be sent to us, depending on your selection. In this case, Apple receives the information that you are a user of our app.\n            The legal basis for the integration of the Apple Sign-In in our app is Art. 6 para. 1 p. 1 lit. f) DSGVO. With the sign-in function, we pursue the legitimate interest of offering you a quick and easy registration option. The sign-in function is therefore in our interest as well as yours. \n            For more information about Apple\'s privacy policy, please visit https://www.apple.com/legal/privacy/de-ww/.\n        2. Registration with email address \n            In addition, you can register directly in our app by entering your e-mail address. We use the so-called double opt-in procedure to confirm the e-mail address you have provided. This means that after your registration, we will send you an email to the email address you provided, in which we ask you to confirm your email address. During registration, you can voluntarily enter your name in your profile.',
  );
}

ActiveSubscriptionDTO activeSubscriptionWithCustomer(CustomerInfo customer) => ActiveSubscriptionDTO(
      customer: customer,
      plans: [
        MockDTO.annualSubscriptionPlan,
        MockDTO.monthlySubscriptionPlan,
      ],
    );

CustomerInfo customerInfoWithEntitlement(EntitlementInfo entitlement, [Package package = MockDTO.monthlyPackage]) {
  return CustomerInfo(
    //entitlements
    EntitlementInfos(
      //all
      {'premium': entitlement},
      //active
      {'premium': entitlement},
    ),
    //allPurchaseDates
    {
      package.storeProduct.identifier: entitlement.latestPurchaseDate,
    },
    //activeSubscriptions
    [package.storeProduct.identifier],
    //allPurchasedProductIdentifiers
    [package.storeProduct.identifier],
    //nonSubscriptionTransactions
    [],
    //firstSeen
    '2022-09-13T22:23:05Z',
    //originalAppUserId
    '\$RCAnonymousID:4574983707c544e0aecf0a1553e1c4b1',
    //allExpirationDates
    {
      package.storeProduct.identifier: entitlement.expirationDate,
    },
    //requestDate
    '2022-09-28T15:59:44Z',
    latestExpirationDate: entitlement.expirationDate,
    originalPurchaseDate: '2013-08-01T07:00:00Z',
    originalApplicationVersion: '1.0',
    managementURL: 'https://apps.apple.com/account/subscriptions',
  );
}

extension ArticleHeaderDTOExtension on ArticleHeaderDTO {
  ArticleHeaderDTO copyWith({
    String? id,
    String? slug,
    String? url,
    String? title,
    String? strippedTitle,
    String? note,
    bool? isNoteCollapsible,
    String? credits,
    ArticleTypeDTO? type,
    ArticleKindDTO? kind,
    String? publicationDate,
    int? timeToRead,
    PublisherDTO? publisher,
    ArticleImageDTO? image,
    String? sourceUrl,
    String? author,
    bool? hasAudioVersion,
    bool? availableInSubscription,
    ArticleProgressDTO? progress,
    ArticleProgressState? progressState,
    bool? locked,
    CategoryDTO? category,
    CurationInfoDTO? curationInfo,
  }) {
    return ArticleHeaderDTO(
      id ?? this.id,
      slug ?? this.slug,
      url ?? this.url,
      title ?? this.title,
      strippedTitle ?? this.strippedTitle,
      note ?? this.note,
      isNoteCollapsible ?? this.isNoteCollapsible,
      type ?? this.type,
      kind ?? this.kind,
      publicationDate ?? this.publicationDate,
      timeToRead ?? this.timeToRead,
      publisher ?? this.publisher,
      image ?? this.image,
      sourceUrl ?? this.sourceUrl,
      author ?? this.author,
      hasAudioVersion ?? this.hasAudioVersion,
      availableInSubscription ?? this.availableInSubscription,
      progress ?? this.progress,
      progressState ?? this.progressState,
      locked ?? this.locked,
      category ?? this.category,
      curationInfo ?? this.curationInfo,
    );
  }

  MediaItemDTO get asMediaItem {
    return MediaItemDTO.article(
      id,
      slug,
      url,
      title,
      strippedTitle,
      note,
      isNoteCollapsible,
      type,
      kind,
      publicationDate,
      timeToRead,
      publisher,
      image,
      sourceUrl,
      author,
      hasAudioVersion,
      availableInSubscription,
      progress,
      progressState,
      locked,
      category,
      curationInfo,
    );
  }

  BriefEntryItemDTO get asBriefEntryItem {
    return BriefEntryItemDTO.article(
      id,
      slug,
      url,
      title,
      strippedTitle,
      note,
      isNoteCollapsible,
      type,
      kind,
      publicationDate,
      timeToRead,
      publisher,
      image,
      sourceUrl,
      author,
      hasAudioVersion,
      availableInSubscription,
      progress,
      progressState,
      locked,
      category,
      curationInfo,
    );
  }
}

extension on TopicDTO {
  TopicDTO copyWith({
    String? id,
    String? slug,
    String? title,
    String? strippedTitle,
    String? introduction,
    String? ownersNote,
    String? url,
    CurationInfoDTO? curationInfo,
    String? lastUpdatedAt,
    TopicPublisherInformationDTO? publisherInformation,
    ImageDTO? heroImage,
    List<EntryDTO>? entries,
    String? summary,
    bool? visited,
    CategoryDTO? category,
  }) {
    return TopicDTO(
      id ?? this.id,
      slug ?? this.slug,
      title ?? this.title,
      strippedTitle ?? this.strippedTitle,
      introduction ?? this.introduction,
      ownersNote ?? this.ownersNote,
      url ?? this.url,
      curationInfo ?? this.curationInfo,
      lastUpdatedAt ?? this.lastUpdatedAt,
      publisherInformation ?? this.publisherInformation,
      heroImage ?? this.heroImage,
      entries ?? this.entries,
      summary ?? this.summary,
      visited ?? this.visited,
      category ?? this.category,
    );
  }

  TopicPreviewDTO get asPreview {
    return TopicPreviewDTO(
      id,
      slug,
      title,
      strippedTitle,
      introduction,
      ownersNote,
      url,
      curationInfo,
      lastUpdatedAt,
      publisherInformation,
      heroImage,
      entries.length,
      visited,
      category,
    );
  }

  BriefEntryItemDTO get asBriefEntryItem {
    return BriefEntryItemDTO.topicPreview(
      id,
      slug,
      title,
      strippedTitle,
      introduction,
      ownersNote,
      url,
      curationInfo,
      lastUpdatedAt,
      publisherInformation,
      heroImage,
      entries.length,
      visited,
      category,
    );
  }
}

extension on BriefDTO {
  BriefDTO copyWith({
    String? id,
    int? unseenCount,
    HeadlineDTO? greeting,
    BriefIntroductionDTO? introduction,
    String? date,
    RelaxDTO? relax,
    List<BriefSectionDTO>? sections,
  }) {
    return BriefDTO(
      id ?? this.id,
      unseenCount ?? this.unseenCount,
      greeting ?? this.greeting,
      introduction ?? this.introduction,
      date ?? this.date,
      relax ?? this.relax,
      sections ?? this.sections,
    );
  }
}
