import 'package:json_annotation/json_annotation.dart';

part 'legal_page_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class LegalPageDTO {
  LegalPageDTO({
    required this.title,
    required this.content,
  });

  factory LegalPageDTO.fromJson(Map<String, dynamic> json) => _$LegalPageDTOFromJson(json);

  final String title;
  final String content;
}
