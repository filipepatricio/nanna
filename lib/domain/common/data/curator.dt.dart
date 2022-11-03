import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'curator.dt.freezed.dart';

@freezed
class Curator with _$Curator {
  factory Curator.editor({
    required String id,
    required String name,
    required String bio,
    Image? avatar,
  }) = EditorCurator;

  factory Curator.expert({
    required String id,
    required String name,
    required String bio,
    required String areaOfExpertise,
    String? instagram,
    String? linkedin,
    String? website,
    String? twitter,
    Image? avatar,
  }) = ExpertCurator;

  factory Curator.editorialTeam({
    required String name,
    required String bio,
    @Default('editorial-team') String id,
    Image? avatar,
  }) = EditorialTeamCurator;

  factory Curator.unknown({
    @Default('') String id,
    @Default('') String name,
    @Default('') String bio,
    Image? avatar,
  }) = UnknownCurator;
}

extension EditorialTeamCuratorExt on ExpertCurator {
  bool get hasSocialMediaLinks => instagram != null || linkedin != null || website != null;
}
