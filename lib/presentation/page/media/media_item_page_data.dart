import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/domain/topic/data/topic.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_page_data.freezed.dart';

@freezed
class MediaItemPageData with _$MediaItemPageData {
  factory MediaItemPageData.singleItem({
    required MediaItemArticle article,
    double? readArticleProgress,
    MediaItemNavigationCallback? navigationCallback,
  }) = _MediaItemPageDataSingleItem;

  factory MediaItemPageData.multipleItems({
    required int index,
    required Topic topic,
    double? readArticleProgress,
    MediaItemNavigationCallback? navigationCallback,
  }) = _MediaItemDataMultipleItems;
}
