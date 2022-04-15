import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.dt.freezed.dart';

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
    ArticleImage? image,
    String? author,
  }) = MediaItemArticle;

  const factory MediaItem.unknown() = _MediaItemUnknown;
}

extension HasImage on MediaItemArticle {
  /// Wether the [MediaItemArticle] has a non-null [image] and this [image] is not [ArticleImageUnknown]
  bool get hasImage => image != null && image is! ArticleImageUnknown;
}
