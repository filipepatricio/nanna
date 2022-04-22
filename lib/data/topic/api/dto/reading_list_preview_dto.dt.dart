import 'package:json_annotation/json_annotation.dart';

part 'reading_list_preview_dto.dt.g.dart';

@JsonSerializable()
class ReadingListPreviewDTO {
  ReadingListPreviewDTO(this.entryCount);

  final int entryCount;

  factory ReadingListPreviewDTO.fromJson(Map<String, dynamic> json) => _$ReadingListPreviewDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingListPreviewDTOToJson(this);
}
