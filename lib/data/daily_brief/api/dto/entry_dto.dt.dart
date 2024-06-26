import 'package:better_informed_mobile/data/daily_brief/api/dto/entry_style_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/media_item_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class EntryDTO {
  EntryDTO(this.item, this.note, this.style);

  factory EntryDTO.fromJson(Map<String, dynamic> json) => _$EntryDTOFromJson(json);
  final String? note;
  final MediaItemDTO item;
  final EntryStyleDTO style;
}
