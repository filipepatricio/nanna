import 'package:better_informed_mobile/data/bookmark/api/dto/bookmark_data_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BookmarkDTO {
  BookmarkDTO(this.id, this.entity);

  factory BookmarkDTO.fromJson(Map<String, dynamic> json) => _$BookmarkDTOFromJson(json);

  final String id;
  final BookmarkDataDTO entity;
}
