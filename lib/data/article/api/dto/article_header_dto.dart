import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_header_dto.g.dart';

@JsonSerializable()
class ArticleHeaderDTO {
  final String slug;
  final String title;
  final String type;
  final String publicationDate;
  final int timeToRead;
  final String sourceUrl;
  final ImageDTO image;
  final PublisherDTO publisher;

  ArticleHeaderDTO(
    this.slug,
    this.title,
    this.type,
    this.publicationDate,
    this.timeToRead,
    this.sourceUrl,
    this.image,
    this.publisher,
  );

  factory ArticleHeaderDTO.fromJson(Map<String, dynamic> json) => _$ArticleHeaderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleHeaderDTOToJson(this);
}
