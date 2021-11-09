import 'package:better_informed_mobile/domain/explore/data/explore_content.dart';

abstract class ExploreContentRepository {
  Future<ExploreContent> getExploreContent();
}
