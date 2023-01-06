import 'package:better_informed_mobile/data/article/api/dto/update_article_progress_response_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/mapper/article_progress_dto_mapper.di.dart';
import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/domain/article/data/update_article_progress_response.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateArticleProgressResponseDTOMapper
    implements Mapper<UpdateArticleProgressResponseDTO, UpdateArticleProgressResponse> {
  UpdateArticleProgressResponseDTOMapper(
    this._articleProgressDTOMapper,
  );

  final ArticleProgressDTOMapper _articleProgressDTOMapper;

  @override
  UpdateArticleProgressResponse call(UpdateArticleProgressResponseDTO data) {
    return UpdateArticleProgressResponse(
      progress: _articleProgressDTOMapper(data.progress),
      progressState: data.progressState,
      freeArticlesLeftWarning: data.freeArticlesLeftWarning,
    );
  }
}
