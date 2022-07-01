import 'package:json_annotation/json_annotation.dart';

part 'navigate_action_args_dto.dt.g.dart';

@JsonSerializable()
class NavigateActionArgsDTO {
  NavigateActionArgsDTO(this.path);

  factory NavigateActionArgsDTO.fromJson(Map<String, dynamic> json) => _$NavigateActionArgsDTOFromJson(json);
  final String path;

  Map<String, dynamic> toJson() => _$NavigateActionArgsDTOToJson(this);
}
