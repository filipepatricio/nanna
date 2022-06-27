import 'package:json_annotation/json_annotation.dart';

part 'bookmark_id_dto.dt.g.dart';

@JsonSerializable()
class BookmarkIdDTO {
  BookmarkIdDTO(this.id);

  factory BookmarkIdDTO.fromJson(Map<String, dynamic> json) => _$BookmarkIdDTOFromJson(json);

  final String id;
}
