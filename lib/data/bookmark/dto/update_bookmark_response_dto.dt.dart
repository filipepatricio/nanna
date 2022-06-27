import 'package:better_informed_mobile/data/bookmark/dto/bookmark_id_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_bookmark_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class UpdateBookmarkResponseDTO {
  UpdateBookmarkResponseDTO(this.successful, this.bookmark);

  factory UpdateBookmarkResponseDTO.fromJson(Map<String, dynamic> json) => _$UpdateBookmarkResponseDTOFromJson(json);

  final bool successful;
  final BookmarkIdDTO bookmark;
}
