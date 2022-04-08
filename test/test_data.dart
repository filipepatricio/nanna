import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/topic/api/mapper/topic_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';

class TestData {
  const TestData._();

  static MediaItemArticle get article =>
      getIt<MediaItemDTOMapper>().call(MockDTO.topic.readingList.entries.first.item) as MediaItemArticle;

  static MediaItemArticle get premiumArticleWithAudio =>
      getIt<MediaItemDTOMapper>().call(MockDTO.premiumMediaItemArticleWithAudio) as MediaItemArticle;

  static Topic get topic => getIt<TopicDTOMapper>().call(MockDTO.topic);

  static Topic get topicWithUnknownOwner => getIt<TopicDTOMapper>().call(MockDTO.topicWithUnknownOwner);

  static Topic get topicWithEditorOwner => getIt<TopicDTOMapper>().call(MockDTO.topicWithEditorOwner);

  static ExploreContent get exploreContent => getIt<ExploreContentDTOMapper>().call(MockDTO.exploreContent);
}
