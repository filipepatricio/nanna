import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:json_annotation/json_annotation.dart';

class Article {
  Article({
    required this.metadata,
    required this.content,
    this.audioFile,
  });
  final MediaItemArticle metadata;
  final ArticleContent content;
  final AudioFile? audioFile;

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
