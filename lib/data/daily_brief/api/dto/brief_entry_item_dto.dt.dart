// ignore_for_file: invalid_annotation_target

import 'package:better_informed_mobile/data/article/api/dto/article_curation_info_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_kind_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_progress_dto.dt.dart';
import 'package:better_informed_mobile/data/article/api/dto/article_type_dto.dart';
import 'package:better_informed_mobile/data/article/api/dto/publisher_dto.dt.dart';
import 'package:better_informed_mobile/data/categories/dto/category_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/article_image_dto.dt.dart';
import 'package:better_informed_mobile/data/image/api/dto/image_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/curator_dto.dt.dart';
import 'package:better_informed_mobile/data/topic/api/dto/topic_publisher_information_dto.dt.dart';
import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brief_entry_item_dto.dt.freezed.dart';
part 'brief_entry_item_dto.dt.g.dart';

@Freezed(unionKey: '__typename', unionValueCase: FreezedUnionCase.pascal, fallbackUnion: unknownKey, toJson: false)
class BriefEntryItemDTO with _$BriefEntryItemDTO {
  @FreezedUnionValue('Article')
  const factory BriefEntryItemDTO.article(
    String id,
    String slug,
    String url,
    String title,
    String strippedTitle,
    String? note,
    String credits,
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
    ArticleCurationInfoDTO curationInfo,
  ) = BriefEntryItemDTOArticle;

  @FreezedUnionValue('Topic')
  const factory BriefEntryItemDTO.topicPreview(
    String id,
    String slug,
    String title,
    String strippedTitle,
    String introduction,
    String url,
    CuratorDTO owner,
    String lastUpdatedAt,
    TopicPublisherInformationDTO publisherInformation,
    ImageDTO heroImage,
    int entryCount,
    bool visited,
    @JsonKey(name: 'primaryCategory') CategoryDTO category,
  ) = BriefEntryItemDTOTopic;

  @FreezedUnionValue(unknownKey)
  factory BriefEntryItemDTO.unknown() = _BriefEntryItemDTOUnknown;

  factory BriefEntryItemDTO.fromJson(Map<String, dynamic> json) => _$BriefEntryItemDTOFromJson(json);
}
