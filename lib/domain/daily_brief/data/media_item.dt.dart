import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_kind.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:better_informed_mobile/domain/article/data/publisher.dart';
import 'package:better_informed_mobile/domain/categories/data/category.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.dt.freezed.dart';

@Freezed(toJson: false)
class MediaItem with _$MediaItem {
  const factory MediaItem.article({
    required String id,
    required String slug,
    required String url,
    required String title,
    required String strippedTitle,
    required String? note,
    required String credits,
    required ArticleType type,
    required ArticleKind? kind,
    required int? timeToRead,
    required Publisher publisher,
    required bool hasAudioVersion,
    required bool availableInSubscription,
    required String sourceUrl,
    required ArticleProgressState progressState,
    required ArticleProgress progress,
    required bool locked,
    required Category category,
    DateTime? publicationDate,
    ArticleImage? image,
    String? author,
  }) = MediaItemArticle;

  const factory MediaItem.unknown() = _MediaItemUnknown;
}

extension Getters on MediaItemArticle {
  bool get hasImage => image != null && image is! ArticleImageUnknown;

  bool get visited =>
      progressState == ArticleProgressState.inProgress || progressState == ArticleProgressState.finished;

  bool get shouldShowArticleCoverNote => note != null;

  String get imageUrl {
    if (image == null) return '';
    if (image is ArticleImageRemote) {
      return (image as ArticleImageRemote).url;
    }
    if (image is ArticleImageCloudinary) {
      return (image as ArticleImageCloudinary).cloudinaryImage.publicId;
    }
    return '';
  }
}
