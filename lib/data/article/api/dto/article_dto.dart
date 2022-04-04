import 'package:better_informed_mobile/data/article/api/dto/article_content_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/image_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_dto.g.dart';

@JsonSerializable()
class ArticleDTO {
  final String id;
  final String slug;
  final String url;
  final String title;
  final String strippedTitle;
  final String credits;
  final String type;
  final String? publicationDate;
  final int timeToRead;
  final PublisherDTO publisher;
  final ImageDTO? image;
  final ArticleContentDTO? text;
  final String sourceUrl;
  final String? author;
  final bool hasAudioVersion;

  ArticleDTO(
    this.id,
    this.slug,
    this.url,
    this.title,
    this.strippedTitle,
    this.credits,
    this.type,
    this.publicationDate,
    this.timeToRead,
    this.publisher,
    this.image,
    this.text,
    this.sourceUrl,
    this.author,
    this.hasAudioVersion,
  );

  factory ArticleDTO.fromJson(Map<String, dynamic> json) => _$ArticleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDTOToJson(this);
}
