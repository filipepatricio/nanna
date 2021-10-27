import 'package:better_informed_mobile/data/article/api/dto/article_dto.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reading_list_dto.g.dart';

@JsonSerializable()
class ReadingListDTO {
  final String id;
  final String name;
  final List<EntryDTO> entries;

  ReadingListDTO(
    this.id,
    this.name,
    this.entries,
  );

  factory ReadingListDTO.fromJson(Map<String, dynamic> json) => _$ReadingListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingListDTOToJson(this);
}
