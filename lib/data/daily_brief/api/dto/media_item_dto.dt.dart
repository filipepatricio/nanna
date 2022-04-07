import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_dto.dt.freezed.dart';
part 'media_item_dto.dt.g.dart';

@Freezed(unionKey: '__typename', unionValueCase: FreezedUnionCase.pascal, fallbackUnion: unknownKey)
class MediaItemDTO with _$MediaItemDTO {
  @FreezedUnionValue('Article')
  const factory MediaItemDTO.article(
    String id,
    String slug,
    String url,
    String title,
    String strippedTitle,
    String credits,
    String type,
    String? publicationDate,
    int? timeToRead,
    PublisherDTO publisher,
    ArticleImageDTO? image,
    String sourceUrl,
    String? author,
    bool hasAudioVersion,
  ) = MediaItemDTOArticle;

  @FreezedUnionValue(unknownKey)
  factory MediaItemDTO.unknown() = _MediaItemDTOUnknown;

  factory MediaItemDTO.fromJson(Map<String, dynamic> json) => _$MediaItemDTOFromJson(json);
}
