import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'article_dto.g.dart';

@JsonSerializable()
class ArticleDTO {
  final int wordCount;
  final String? note;
  final String id;
  final String slug;
  final String title;
  final String type;
  final String publicationDate;
  final int timeToRead;
  final PublisherDTO publisher;
  final ImageDTO? image;
  final ArticleContentDTO? text;
  final String sourceUrl;
  final String? author;

  ArticleDTO(
    this.wordCount,
    this.note,
    this.id,
    this.slug,
    this.text,
    this.title,
    this.type,
    this.publicationDate,
    this.timeToRead,
    this.sourceUrl,
    this.image,
    this.publisher,
    this.author,
  );

  factory ArticleDTO.fromJson(Map<String, dynamic> json) => _$ArticleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDTOToJson(this);
}
