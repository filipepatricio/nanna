import 'package:better_informed_mobile/domain/article/data/article_content.dt.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.dt.freezed.dart';

@freezed
class Article with _$Article {
  factory Article({
    required MediaItemArticle metadata,
    required ArticleContent content,
    AudioFile? audioFile,
  }) = _Article;

  Article._();

  bool get hasImage => metadata.hasImage;
}

enum ArticleType { free, premium }

enum ArticleProgressState {
  @JsonValue("FINISHED")
  finished,
  @JsonValue("IN_PROGRESS")
  inProgress,
  @JsonValue("UNREAD")
  unread,
}
