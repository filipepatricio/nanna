import 'package:json_annotation/json_annotation.dart';

part 'reading_list_count_dto.dt.g.dart';

@JsonSerializable()
class ReadingListCountDTO {
  ReadingListCountDTO(this.entryCount);

  final int entryCount;

  factory ReadingListCountDTO.fromJson(Map<String, dynamic> json) => _$ReadingListCountDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingListCountDTOToJson(this);
}
