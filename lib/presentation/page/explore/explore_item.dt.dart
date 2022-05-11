import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_pill.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_item.dt.freezed.dart';

@freezed
class ExploreItem with _$ExploreItem {
  factory ExploreItem.pills(List<ExploreContentPill> list) = _ExploreItemPills;

  factory ExploreItem.stream(ExploreContentArea area) = _ExploreItemArea;
}
