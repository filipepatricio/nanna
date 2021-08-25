import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_dto.g.dart';

@JsonSerializable()
class ArticleDTO {
  final String slug;
  final String title;
  final String type;
  final String publicationDate;
  final int timeToRead;
  final ImageDTO image;
  final PublisherDTO publisher;
  final ArticleContentDTO? text;
  final String? sourceUrl;

  ArticleDTO(
    this.slug,
    this.text,
    this.title,
    this.type,
    this.publicationDate,
    this.timeToRead,
    this.sourceUrl,
    this.image,
    this.publisher,
  );

  factory ArticleDTO.fromJson(Map<String, dynamic> json) => _$ArticleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDTOToJson(this);
}
