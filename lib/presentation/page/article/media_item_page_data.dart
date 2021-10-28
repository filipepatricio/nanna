import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/presentation/page/article/media_item_page.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_page_data.freezed.dart';

@freezed
class MediaItemPageData with _$MediaItemPageData {
  factory MediaItemPageData.singleItem({
    required Entry entry,
    double? readArticleProgress,
    MediaItemNavigationCallback? navigationCallback,
  }) = _MediaItemPageDataSingleItem;

  factory MediaItemPageData.multipleItems({
    required int index,
    required List<Entry> entryList,
    double? readArticleProgress,
    MediaItemNavigationCallback? navigationCallback,
  }) = _MediaItemDataMultipleItems;
}
