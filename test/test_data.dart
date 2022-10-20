import 'package:better_informed_mobile/data/article/api/mapper/article_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_content_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_kind_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_progress_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/categories/mapper/category_with_items_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_item_media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_style_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_entry_topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_introduction_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_section_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/brief_subsection_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/call_to_action_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_style_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/headline_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/past_days_brief_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/relax_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_pill_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_preview_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_publisher_information_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_position.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/categories/data/category_item.dt.dart';
import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/past_days_brief.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/data/subscription_plan.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/active_subscription_mapper.di.dart';
import 'package:better_informed_mobile/domain/subscription/mapper/subscription_plan_mapper.di.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

class TestData {
  const TestData._();

  static final _mediaItemMapper = MediaItemDTOMapper(
    ArticleImageDTOMapper(),
    PublisherDTOMapper(
      ImageDTOMapper(),
    ),
    ArticleTypeDTOMapper(),
    ArticleKindDTOMapper(),
    ArticleProgressDTOMapper(),
    CategoryDTOMapper(),
  );

  static final _topicPreviewMapper = TopicPreviewDTOMapper(
    TopicOwnerDTOMapper(
      ImageDTOMapper(),
    ),
    TopicPublisherInformationDTOMapper(
      PublisherDTOMapper(
        ImageDTOMapper(),
      ),
    ),
    ImageDTOMapper(),
    CategoryDTOMapper(),
  );

  static final _topicMapper = TopicDTOMapper(
    ImageDTOMapper(),
    EntryDTOMapper(
      _mediaItemMapper,
      EntryStyleDTOMapper(),
    ),
    SummaryCardDTOMapper(),
    TopicPublisherInformationDTOMapper(
      PublisherDTOMapper(
        ImageDTOMapper(),
      ),
    ),
    TopicOwnerDTOMapper(
      ImageDTOMapper(),
    ),
    CategoryDTOMapper(),
  );

  static final _exploreContentMapper = ExploreContentDTOMapper(
    ExploreContentPillDTOMapper(),
    ExploreContentAreaDTOMapper(
      _articleToMediaItemMapper,
      _topicPreviewMapper,
    ),
  );

  static final _currentBriefMapper = BriefDTOMapper(
    HeadlineDTOMapper(),
    BriefIntroductionDTOMapper(),
    BriefSectionDTOMapper(
      _briefEntryDTOMapper,
      BriefSubsectionDTOMapper(
        _briefEntryDTOMapper,
      ),
    ),
    RelaxDTOMapper(
      CallToActionDTOMapper(),
    ),
  );

  static final _briefEntryDTOMapper = BriefEntryDTOMapper(
    BriefEntryItemDTOMapper(
      BriefEntryMediaItemDTOMapper(
        ArticleImageDTOMapper(),
        PublisherDTOMapper(
          ImageDTOMapper(),
        ),
        ArticleTypeDTOMapper(),
        ArticleKindDTOMapper(),
        ArticleProgressDTOMapper(),
        CategoryDTOMapper(),
      ),
      BriefEntryTopicPreviewDTOMapper(
        TopicOwnerDTOMapper(
          ImageDTOMapper(),
        ),
        TopicPublisherInformationDTOMapper(
          PublisherDTOMapper(
            ImageDTOMapper(),
          ),
        ),
        ImageDTOMapper(),
        CategoryDTOMapper(),
      ),
    ),
    BriefEntryStyleDTOMapper(),
  );

  static final _pastDaysBriefMapper = PastDaysBriefDTOMapper(_currentBriefMapper);

  static final _articleToMediaItemMapper = ArticleDTOToMediaItemMapper(
    ArticleImageDTOMapper(),
    PublisherDTOMapper(
      ImageDTOMapper(),
    ),
    ArticleTypeDTOMapper(),
    ArticleKindDTOMapper(),
    ArticleProgressDTOMapper(),
    CategoryDTOMapper(),
  );

  static final _categoryItemMapper = CategoryItemDTOMapper(
    _topicPreviewMapper,
    _articleToMediaItemMapper,
  );

  static final _categoryMapper = CategoryDTOMapper();

  static final _categoryWithItemsMapper = CategoryWithItemsDTOMapper(_categoryItemMapper);

  static final _articleContentMapper = ArticleContentDTOMapper(
    ArticleContentTypeDTOMapper(),
  );

  static final _subscriptionPlanMapper = SubscriptionPlanMapper();

  static final _activeSubscriptionMapper = ActiveSubscriptionMapper(AppConfig.mock);

  static AudioItem get audioItem => AudioItem(
        id: TestData.premiumArticleWithAudio.id,
        slug: TestData.premiumArticleWithAudio.slug,
        title: 'Some title',
        author: 'New York Times',
        imageUrl: null,
        duration: const Duration(seconds: 360),
      );

  static AudioPosition get audioPosition => AudioPosition(
        audioItemID: premiumArticleWithAudio.id,
        position: const Duration(seconds: 120),
        totalDuration: const Duration(seconds: 360),
      );

  static Article get fullArticle => Article(
        metadata: article,
        content: _articleContentMapper(MockDTO.articleContentMarkdown),
      );

  static MediaItemArticle get article => _mediaItemMapper(MockDTO.topic.entries.first.item) as MediaItemArticle;

  static MediaItemArticle get premiumArticleWithoutImage =>
      _mediaItemMapper(MockDTO.premiumArticleWithoutImage.asMediaItem) as MediaItemArticle;

  static MediaItemArticle get premiumArticleWithAudio =>
      _mediaItemMapper(MockDTO.premiumArticleWithAudio.asMediaItem) as MediaItemArticle;

  static MediaItemArticle get premiumArticleWithAudioAndLocked =>
      _mediaItemMapper(MockDTO.premiumArticleWithAudioLocked.asMediaItem) as MediaItemArticle;

  static Topic get topic => _topicMapper(MockDTO.topic);

  static Topic get topicWithUnknownOwner => _topicMapper(MockDTO.topicWithUnknownOwner);

  static Topic get topicWithEditorOwner => _topicMapper(MockDTO.topicWithEditorOwner);

  static ExploreContent get exploreContent => _exploreContentMapper(MockDTO.exploreContent);

  static ExploreContent get exploreContentVisited => _exploreContentMapper(MockDTO.exploreContentVisited);

  static Brief get currentBrief => _currentBriefMapper(MockDTO.currentBrief());

  static Brief get currentBriefVisited => _currentBriefMapper(MockDTO.currentBriefVisited);

  static List<PastDaysBrief> get pastDaysBriefs =>
      MockDTO.pastDaysBriefs.map<PastDaysBrief>(_pastDaysBriefMapper).toList();

  static Category get category => _categoryMapper(MockDTO.category);

  static CategoryWithItems get categoryWithItems => _categoryWithItemsMapper(MockDTO.categoryWithItems);

  static List<CategoryItem> get categoryItemList =>
      MockDTO.categoryItemList.map<CategoryItem>(_categoryItemMapper).toList();

  static ActiveSubscriptionPremium get activeSubscription =>
      _activeSubscriptionMapper(MockDTO.activeSubscription) as ActiveSubscriptionPremium;

  static ActiveSubscriptionManualPremium get activeSubscriptionManual =>
      _activeSubscriptionMapper(MockDTO.activeSubscriptionManual) as ActiveSubscriptionManualPremium;

  static ActiveSubscriptionTrial get activeSubscriptionTrial =>
      _activeSubscriptionMapper(MockDTO.activeSubscriptionTrial) as ActiveSubscriptionTrial;

  static List<SubscriptionPlan> get subscriptionPlansWithTrial => _subscriptionPlanMapper(MockDTO.offeringWithTrial);

  static List<SubscriptionPlan> get subscriptionPlansWithoutTrial =>
      _subscriptionPlanMapper(MockDTO.offeringWithoutTrial);

  static String? get freeArticlesLeftWarning => MockDTO.updateArticleProgressResponseWarning.freeArticlesLeftWarning;
}
