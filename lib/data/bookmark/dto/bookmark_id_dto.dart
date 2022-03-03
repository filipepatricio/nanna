import 'package:json_annotation/json_annotation.dart';

part 'bookmark_id_dto.g.dart';

@JsonSerializable()
class BookmarkIdDTO {
  BookmarkIdDTO(this.id);

  final String id;

  factory BookmarkIdDTO.fromJson(Map<String, dynamic> json) => _$BookmarkIdDTOFromJson(json);
}
