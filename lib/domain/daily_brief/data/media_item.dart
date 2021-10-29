import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem.article({
    required int wordCount,
    required String id,
    required String slug,
    required String title,
    required ArticleType type,
    required int timeToRead,
    required Publisher publisher,
    required String sourceUrl,
    DateTime? publicationDate,
    String? note,
    Image? image,
    ArticleContent? text,
    String? author,
  }) = MediaItemArticle;
}
