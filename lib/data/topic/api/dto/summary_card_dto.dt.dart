import 'package:json_annotation/json_annotation.dart';

part 'summary_card_dto.dt.g.dart';

@JsonSerializable()
class SummaryCardDTO {
  final String text;

  SummaryCardDTO(this.text);

  factory SummaryCardDTO.fromJson(Map<String, dynamic> json) => _$SummaryCardDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryCardDTOToJson(this);
}
