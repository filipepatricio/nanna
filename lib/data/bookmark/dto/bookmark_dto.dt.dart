import 'package:better_informed_mobile/data/bookmark/dto/bookmark_data_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BookmarkDTO {
  BookmarkDTO(this.id, this.entity);

  final String id;
  final BookmarkDataDTO entity;

  factory BookmarkDTO.fromJson(Map<String, dynamic> json) => _$BookmarkDTOFromJson(json);
}
