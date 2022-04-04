import 'package:json_annotation/json_annotation.dart';

part 'navigate_action_args_dto.dt.g.dart';

@JsonSerializable()
class NavigateActionArgsDTO {
  final String path;

  NavigateActionArgsDTO(this.path);

  factory NavigateActionArgsDTO.fromJson(Map<String, dynamic> json) => _$NavigateActionArgsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NavigateActionArgsDTOToJson(this);
}
