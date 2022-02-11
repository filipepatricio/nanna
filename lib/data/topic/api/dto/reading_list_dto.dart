import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reading_list_dto.g.dart';

@JsonSerializable()
class ReadingListDTO {
  final String id;
  final List<EntryDTO> entries;

  ReadingListDTO(
    this.id,
    this.entries,
  );

  factory ReadingListDTO.fromJson(Map<String, dynamic> json) => _$ReadingListDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingListDTOToJson(this);
}
