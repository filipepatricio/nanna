import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_publisher_information.dart';

class TopicPreview {
  TopicPreview(
    this.id,
    this.slug,
    this.title,
    this.strippedTitle,
    this.introduction,
    this.url,
    this.owner,
    this.lastUpdatedAt,
    this.publisherInformation,
    this.heroImage,
    this.entryCount,
    this.visited,
  );

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final TopicOwner owner;
  final DateTime lastUpdatedAt;
  final TopicPublisherInformation publisherInformation;
  final Image heroImage;
  final int entryCount;
  final bool visited;
}
