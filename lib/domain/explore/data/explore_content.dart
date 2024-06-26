import 'package:better_informed_mobile/domain/explore/data/explore_content_area.dt.dart';
import 'package:better_informed_mobile/domain/explore/data/explore_content_pill.dt.dart';

class ExploreContent {
  ExploreContent({
    required this.areas,
    this.pills,
  });
  final List<ExploreContentPill>? pills;
  final List<ExploreContentArea> areas;
}
