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
    required String url,
    required String title,
    required String strippedTitle,
    required String credits,
    required ArticleType type,
    required int? timeToRead,
    required Publisher publisher,
    required bool hasAudioVersion,
    required String sourceUrl,
    DateTime? publicationDate,
    Image? image,
    String? author,
  }) = MediaItemArticle;

  const factory MediaItem.unknown() = _MediaItemUnknown;
}
