import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/data/daily_brief/api/mapper/media_item_dto_mapper.dart';
import 'package:better_informed_mobile/data/explore/api/mapper/explore_content_dto_mapper.dart';
import 'package:better_informed_mobile/data/util/mock_dto_creators.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';

class TestData {
  const TestData._();

  static MediaItemArticle get article =>
      getIt<MediaItemDTOMapper>().call(MockDTO.topic.readingList.entries.first.item) as MediaItemArticle;

  static ExploreContent get exploreContent => getIt<ExploreContentDTOMapper>().call(MockDTO.exploreContent);
}
