import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/common/data/curation_info.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';

class TopicPreview {
  const TopicPreview(
    this.id,
    this.slug,
    this.title,
    this.strippedTitle,
    this.introduction,
    this.url,
    this.curationInfo,
    this.lastUpdatedAt,
    this.publisherInformation,
    this.heroImage,
    this.entryCount,
    this.visited,
    this.category,
  );

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final CurationInfo curationInfo;
  final DateTime lastUpdatedAt;
  final TopicPublisherInformation publisherInformation;
  final Image heroImage;
  final int entryCount;
  final bool visited;
  final Category category;
}
