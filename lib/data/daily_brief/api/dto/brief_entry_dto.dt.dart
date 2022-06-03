import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_item_dto.dt.dart';
import 'package:better_informed_mobile/data/daily_brief/api/dto/brief_entry_style_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'brief_entry_dto.dt.g.dart';

@JsonSerializable()
class BriefEntryDTO {
  final BriefEntryItemDTO item;
  final BriefEntryStyleDTO style;

  BriefEntryDTO(this.item, this.style);

  factory BriefEntryDTO.fromJson(Map<String, dynamic> json) => _$BriefEntryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$BriefEntryDTOToJson(this);
}
