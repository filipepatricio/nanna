import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem.article({
    required String id,
    required String slug,
    required String title,
    required String strippedTitle,
    required ArticleType type,
    required int? timeToRead,
    required Publisher publisher,
    required String sourceUrl,
    DateTime? publicationDate,
    Image? image,
    String? author,
  }) = MediaItemArticle;
}
