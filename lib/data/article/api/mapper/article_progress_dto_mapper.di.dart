import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/article_progress.dart';
import 'package:injectable/injectable.dart';

@injectable
class ArticleProgressDTOMapper implements Mapper<ArticleProgressDTO, ArticleProgress> {
  ArticleProgressDTOMapper();

  @override
  ArticleProgress call(ArticleProgressDTO data) {
    return ArticleProgress(
      audioPosition: data.audioPosition,
      audioProgress: data.audioProgress,
      contentProgress: data.contentProgress,
    );
  }
}
