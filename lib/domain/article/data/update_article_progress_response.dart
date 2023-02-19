import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';

class UpdateArticleProgressResponse {
  UpdateArticleProgressResponse({
    required this.progress,
    required this.progressState,
    this.freeArticlesLeftWarning,
  });

  final ArticleProgress progress;
  final ArticleProgressState progressState;
  final String? freeArticlesLeftWarning;
}
