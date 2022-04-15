import 'package:better_informed_mobile/data/article/api/mapper/article_dto_to_media_item_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_type_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/article/api/mapper/publisher_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/entry_style_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/reading_list_entries_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_area_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/article_image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/image/api/mapper/image_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/reading_list_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/summary_card_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_owner_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/color_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/audio/data/audio_item.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/audio/player_banner/audio_player_banner_state.dt.dart';
import 'package:flutter_test/flutter_test.dart';

class TestData {
  const TestData._();

  static final _mediaItemMapper = MediaItemDTOMapper(
    ArticleImageDTOMapper(),
    PublisherDTOMapper(
      ImageDTOMapper(),
    ),
    ArticleTypeDTOMapper(),
  );

  static final _topicMapper = TopicDTOMapper(
    ImageDTOMapper(),
    ReadingListDTOMapper(
      ReadingListEntriesDTOMapper(
        _mediaItemMapper,
        EntryStyleDTOMapper(),
      ),
    ),
    SummaryCardDTOMapper(),
    PublisherDTOMapper(
      ImageDTOMapper(),
    ),
    TopicOwnerDTOMapper(
      ImageDTOMapper(),
    ),
  );

  static final _exploreContentMapper = ExploreContentDTOMapper(
    ExploreContentAreaDTOMapper(
      ArticleDTOToMediaItemMapper(
        ArticleImageDTOMapper(),
        PublisherDTOMapper(
          ImageDTOMapper(),
        ),
        ArticleTypeDTOMapper(),
      ),
      _topicMapper,
      ColorDTOMapper(),
    ),
  );

  static MediaItemArticle get article =>
      _mediaItemMapper(MockDTO.topic.readingList.entries.first.item) as MediaItemArticle;

  static MediaItemArticle get premiumArticleWithAudio =>
      _mediaItemMapper(MockDTO.premiumMediaItemArticleWithAudio) as MediaItemArticle;

  static Topic get topic => _topicMapper(MockDTO.topic);

  static Topic get topicWithUnknownOwner => _topicMapper(MockDTO.topicWithUnknownOwner);

  static Topic get topicWithEditorOwner => _topicMapper(MockDTO.topicWithEditorOwner);

  static ExploreContent get exploreContent => _exploreContentMapper(MockDTO.exploreContent);
}

class AudioPlayerBannerCubitFake extends Fake implements AudioPlayerBannerCubit {
  @override
  Future<void> initialize() async {}

  @override
  AudioPlayerBannerState get state => AudioPlayerBannerState.visible(
        AudioItem(
          id: '000',
          author: 'Cool author',
          imageUrl: 'www.url.com',
          slug: 'cool-audio',
          title: 'Cool audio title',
        ),
      );

  @override
  Stream<AudioPlayerBannerState> get stream => Stream.value(state);

  @override
  Future<void> close() async {}
}
