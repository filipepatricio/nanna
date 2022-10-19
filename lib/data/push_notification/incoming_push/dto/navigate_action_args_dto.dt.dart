import 'package:json_annotation/json_annotation.dart';

part 'navigate_action_args_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class NavigateActionArgsDTO {
  NavigateActionArgsDTO(this.path);

  factory NavigateActionArgsDTO.fromJson(Map<String, dynamic> json) => _$NavigateActionArgsDTOFromJson(json);
  final String path;
}
