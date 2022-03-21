import 'package:better_informed_mobile/data/bookmark/dto/bookmark_id_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_bookmark_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class UpdateBookmarkResponseDTO {
  UpdateBookmarkResponseDTO(this.successful, this.bookmark);

  final bool successful;
  final BookmarkIdDTO bookmark;

  factory UpdateBookmarkResponseDTO.fromJson(Map<String, dynamic> json) => _$UpdateBookmarkResponseDTOFromJson(json);
}
