import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_dto.g.dart';

@JsonSerializable()
class EntryDTO {
  final String? note;
  final MediaItemDTO item;

  EntryDTO(this.item, this.note);

  factory EntryDTO.fromJson(Map<String, dynamic> json) => _$EntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EntryDTOToJson(this);
}
