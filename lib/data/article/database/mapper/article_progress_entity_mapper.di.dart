import 'package:better_informed_mobile/data/article/database/entity/article_progress_entity.hv.dart';
import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleProgressEntityMapper extends BidirectionalMapper<ArticleProgressEntity, ArticleProgress> {
  @override
  ArticleProgressEntity from(ArticleProgress data) {
    return ArticleProgressEntity(
      audioPosition: data.audioPosition,
      audioProgress: data.audioProgress,
      contentProgress: data.contentProgress,
    );
  }

  @override
  ArticleProgress to(ArticleProgressEntity data) {
    return ArticleProgress(
      audioPosition: data.audioPosition,
      audioProgress: data.audioProgress,
      contentProgress: data.contentProgress,
    );
  }
}
