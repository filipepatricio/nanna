import 'package:json_annotation/json_annotation.dart';

part 'invite_code_dto.g.dart';

@JsonSerializable()
class InviteCodeDTO {
  InviteCodeDTO({
    required this.id,
    required this.code,
    required this.useCount,
    required this.maxUseCount,
  });

  final String id;
  final String code;
  final int useCount;
  final int maxUseCount;

  factory InviteCodeDTO.fromJson(Map<String, dynamic> json) => _$InviteCodeDTOFromJson(json);
}
