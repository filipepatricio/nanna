import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_type_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_header_dto.dt.g.dart';

@JsonSerializable()
class ArticleHeaderDTO {
  ArticleHeaderDTO(
    this.id,
    this.slug,
    this.url,
    this.title,
    this.strippedTitle,
    this.note,
    this.credits,
    this.type,
    this.kind,
    this.publicationDate,
    this.timeToRead,
    this.publisher,
    this.image,
    this.sourceUrl,
    this.author,
    this.hasAudioVersion,
    this.availableInSubscription,
    this.progress,
    this.progressState,
    this.locked,
  );

  factory ArticleHeaderDTO.fromJson(Map<String, dynamic> json) => _$ArticleHeaderDTOFromJson(json);
  final String id;
  final String slug;
  final String url;
  final String title;
  final String strippedTitle;
  final String credits;
  final String? note;
  final ArticleTypeDTO type;
  final ArticleKindDTO? kind;
  final String? publicationDate;
  final int timeToRead;
  final PublisherDTO publisher;
  @JsonKey(name: 'articleImage')
  final ArticleImageDTO? image;
  final String sourceUrl;
  final String? author;
  final bool hasAudioVersion;
  final bool availableInSubscription;
  final ArticleProgressDTO progress;
  final ArticleProgressState progressState;
  final bool locked;

  Map<String, dynamic> toJson() => _$ArticleHeaderDTOToJson(this);
}
