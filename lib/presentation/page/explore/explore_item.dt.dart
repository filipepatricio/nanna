import 'package:better_informed_mobile/domain/categories/data/category_with_items.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_item.dt.freezed.dart';

@Freezed(toJson: false)
class ExploreItem with _$ExploreItem {
  factory ExploreItem.pills(List<CategoryWithItems> categories) = _ExploreItemPills;

  factory ExploreItem.stream(ExploreContentArea area) = _ExploreItemArea;
}
