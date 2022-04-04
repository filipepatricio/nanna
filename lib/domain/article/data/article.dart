import 'package:better_informed_mobile/domain/article/data/article_content.dart';
import 'package:better_informed_mobile/domain/article/data/audio_file.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';

enum ArticleType { free, premium }

class Article {
  final ArticleContent content;
  final MediaItemArticle article;
  final AudioFile? audioFile;

  Article({
    required this.content,
    required this.article,
    this.audioFile,
  });
}
