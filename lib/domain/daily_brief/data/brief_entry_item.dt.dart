import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_kind.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/entry.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_owner.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_item.dt.freezed.dart';

@freezed
class BriefEntryItem with _$BriefEntryItem {
  const factory BriefEntryItem.article({
    required String id,
    required String slug,
    required String url,
    required String title,
    required String strippedTitle,
    required String credits,
    required ArticleType type,
    required ArticleKind? kind,
    required int? timeToRead,
    required Publisher publisher,
    required bool hasAudioVersion,
    required String sourceUrl,
    DateTime? publicationDate,
    ArticleImage? image,
    String? author,
  }) = BriefEntryItemArticle;

  const factory BriefEntryItem.topic({
    required String id,
    required String slug,
    required String title,
    required String strippedTitle,
    required String introduction,
    required String url,
    required TopicOwner owner,
    required DateTime lastUpdatedAt,
    required List<Publisher> highlightedPublishers,
    required Image heroImage,
    required Image coverImage,
    required List<Entry> entries,
    required List<TopicSummary> topicSummaryList,
  }) = BriefEntryItemTopic;

  const factory BriefEntryItem.unknown() = _BriefEntryItemUnknown;
}

extension HasImage on BriefEntryItemArticle {
  /// Wether the [MediaItemArticle] has a non-null [image] and this [image] is not [ArticleImageUnknown]
  bool get hasImage => image != null && image is! ArticleImageUnknown;
}
