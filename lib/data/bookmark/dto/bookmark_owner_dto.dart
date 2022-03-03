import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_owner_dto.freezed.dart';
part 'bookmark_owner_dto.g.dart';

@Freezed(unionKey: '__typename')
class BookmarkOwnerDTO with _$BookmarkOwnerDTO {
  @FreezedUnionValue('topic')
  factory BookmarkOwnerDTO.topic() = _BookmarkOwnerDTOTopic;

  @FreezedUnionValue('article')
  factory BookmarkOwnerDTO.article() = _BookmarkOwnerDTOArticle;

  factory BookmarkOwnerDTO.fromJson(Map<String, dynamic> json) => _$BookmarkOwnerDTOFromJson(json);
}
