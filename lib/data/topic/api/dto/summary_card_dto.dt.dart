import 'package:json_annotation/json_annotation.dart';

part 'summary_card_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class SummaryCardDTO {
  SummaryCardDTO(this.text);

  factory SummaryCardDTO.fromJson(Map<String, dynamic> json) => _$SummaryCardDTOFromJson(json);
  final String text;
}
