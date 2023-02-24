import 'package:json_annotation/json_annotation.dart';

part 'badge_count_args_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class BadgeCountArgsDTO {
  BadgeCountArgsDTO(this.badgeCount);

  factory BadgeCountArgsDTO.fromJson(Map<String, dynamic> json) => _$BadgeCountArgsDTOFromJson(json);
  final int badgeCount;
}
