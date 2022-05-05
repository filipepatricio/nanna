import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';

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
    this.highlightedPublishers,
    this.heroImage,
    this.coverImage,
    this.entryCount,
  );

  final String id;
  final String slug;
  final String title;
  final String strippedTitle;
  final String introduction;
  final String url;
  final TopicOwner owner;
  final DateTime lastUpdatedAt;
  final List<Publisher> highlightedPublishers;
  final Image heroImage;
  final Image coverImage;
  final int? entryCount;
}
