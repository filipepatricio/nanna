import 'package:better_informed_mobile/data/bookmark/dto/bookmark_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_list_dto.g.dart';

@JsonSerializable(createToJson: false)
class BookmarkListDTO {
  BookmarkListDTO(this.bookmarks);

  @JsonKey(name: 'getBookmarks')
  final List<BookmarkDTO> bookmarks;

  factory BookmarkListDTO.fromJson(Map<String, dynamic> json) => _$BookmarkListDTOFromJson(json);
}
