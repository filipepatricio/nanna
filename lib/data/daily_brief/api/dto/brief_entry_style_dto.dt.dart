import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brief_entry_style_dto.dt.g.dart';

@JsonSerializable()
class BriefEntryStyleDTO {
  BriefEntryStyleDTO(this.backgroundColor, this.type);

  factory BriefEntryStyleDTO.fromJson(Map<String, dynamic> json) => _$BriefEntryStyleDTOFromJson(json);
  final String? backgroundColor;
  final BriefEntryStyleType type;

  Map<String, dynamic> toJson() => _$BriefEntryStyleDTOToJson(this);
}
