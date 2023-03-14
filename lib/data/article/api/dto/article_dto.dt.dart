import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_header_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/audio_file_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class ArticleDTO {
  ArticleDTO({
    required this.header,
    required this.content,
    required this.audioFile,
  });

  factory ArticleDTO.fromJson(Map<String, dynamic> json) => _$ArticleDTOFromJson(json);

  final ArticleHeaderDTO header;
  final ArticleContentDTO content;
  final AudioFileDTO? audioFile;
}
