import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_style_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class EntryStyleDTO {
  EntryStyleDTO(this.color, this.type);

  factory EntryStyleDTO.fromJson(Map<String, dynamic> json) => _$EntryStyleDTOFromJson(json);
  final String color;
  final EntryStyleType type;
}
