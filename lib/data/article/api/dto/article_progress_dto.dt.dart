import 'package:json_annotation/json_annotation.dart';

part 'article_progress_dto.dt.g.dart';

@JsonSerializable()
class ArticleProgressDTO {
  ArticleProgressDTO(
    this.audioPosition,
    this.audioProgress,
    this.contentProgress,
  );

  factory ArticleProgressDTO.fromJson(Map<String, dynamic> json) => _$ArticleProgressDTOFromJson(json);
  final int audioPosition;
  final int audioProgress;
  final int contentProgress;

  Map<String, dynamic> toJson() => _$ArticleProgressDTOToJson(this);
}
