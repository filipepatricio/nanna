// ignore_for_file: invalid_annotation_target

import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_type_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/common/dto/curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item_dto.dt.freezed.dart';
part 'media_item_dto.dt.g.dart';

@Freezed(unionKey: '__typename', unionValueCase: FreezedUnionCase.pascal, fallbackUnion: unknownKey, toJson: false)
class MediaItemDTO with _$MediaItemDTO {
  @FreezedUnionValue('Article')
  const factory MediaItemDTO.article(
    String id,
    String slug,
    String url,
    String title,
    String strippedTitle,
    String? note,
    bool isNoteCollapsible,
    ArticleTypeDTO type,
    ArticleKindDTO? kind,
    String? publicationDate,
    int? timeToRead,
    PublisherDTO publisher,
    @JsonKey(name: 'articleImage') ArticleImageDTO? image,
    String sourceUrl,
    String? author,
    bool hasAudioVersion,
    bool availableInSubscription,
    ArticleProgressDTO progress,
    ArticleProgressState progressState,
    bool locked,
    @JsonKey(name: 'primaryCategory') CategoryDTO category,
    CurationInfoDTO curationInfo,
  ) = MediaItemDTOArticle;

  @FreezedUnionValue(unknownKey)
  factory MediaItemDTO.unknown() = _MediaItemDTOUnknown;

  factory MediaItemDTO.fromJson(Map<String, dynamic> json) => _$MediaItemDTOFromJson(json);
}
