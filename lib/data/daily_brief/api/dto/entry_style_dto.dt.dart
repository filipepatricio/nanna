import 'package:better_informed_mobile/domain/daily_brief/data/entry_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entry_style_dto.dt.g.dart';

@JsonSerializable()
class EntryStyleDTO {
  final String color;
  final EntryStyleType type;

  EntryStyleDTO(this.color, this.type);

  factory EntryStyleDTO.fromJson(Map<String, dynamic> json) => _$EntryStyleDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EntryStyleDTOToJson(this);
}
