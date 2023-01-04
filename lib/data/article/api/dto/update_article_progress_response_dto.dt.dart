import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_article_progress_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class UpdateArticleProgressResponseDTO {
  UpdateArticleProgressResponseDTO(
    this.progress,
    this.progressState,
    this.freeArticlesLeftWarning,
  );

  factory UpdateArticleProgressResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdateArticleProgressResponseDTOFromJson(json);

  final ArticleProgressDTO progress;
  final ArticleProgressState progressState;
  final String? freeArticlesLeftWarning;
}
