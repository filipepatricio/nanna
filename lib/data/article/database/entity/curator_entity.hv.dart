import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'curator_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.curatorEntity)
class CuratorEntity {
  CuratorEntity({
    CuratorExpertEntity? expert,
    CuratorEditorEntity? editor,
    CuratorEditorialTeamEntity? editorialTeam,
    CuratorUnknownEntity? unknown,
  })  : _expert = expert,
        _editor = editor,
        _editorialTeam = editorialTeam,
        _unknown = unknown;

  CuratorEntity.expert(CuratorExpertEntity expert) : this(expert: expert);

  CuratorEntity.editor(CuratorEditorEntity editor) : this(editor: editor);

  CuratorEntity.editorialTeam(CuratorEditorialTeamEntity editorialTeam) : this(editorialTeam: editorialTeam);

  CuratorEntity.unknown() : this(unknown: CuratorUnknownEntity());

  T map<T>({
    required T Function(CuratorExpertEntity expert) expert,
    required T Function(CuratorEditorEntity editor) editor,
    required T Function(CuratorEditorialTeamEntity editorialTeam) editorialTeam,
    required T Function(CuratorUnknownEntity unknown) unknown,
  }) {
    if (_expert != null) {
      return expert(_expert!);
    } else if (_editor != null) {
      return editor(_editor!);
    } else if (_editorialTeam != null) {
      return editorialTeam(_editorialTeam!);
    } else if (_unknown != null) {
      return unknown(_unknown!);
    } else {
      throw Exception('Invalid state');
    }
  }

  @HiveField(0)
  final CuratorExpertEntity? _expert;
  @HiveField(1)
  final CuratorEditorEntity? _editor;
  @HiveField(2)
  final CuratorEditorialTeamEntity? _editorialTeam;
  @HiveField(3)
  final CuratorUnknownEntity? _unknown;
}

@HiveType(typeId: HiveTypes.curatorExpertEntity)
class CuratorExpertEntity {
  CuratorExpertEntity({
    required this.id,
    required this.name,
    required this.bio,
    required this.areaOfExpertise,
    required this.instagram,
    required this.linkedin,
    required this.website,
    required this.twitter,
    required this.avatar,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String bio;
  @HiveField(3)
  final String areaOfExpertise;
  @HiveField(4)
  final String? instagram;
  @HiveField(5)
  final String? linkedin;
  @HiveField(6)
  final String? website;
  @HiveField(7)
  final String? twitter;
  @HiveField(8)
  final ImageEntity? avatar;
}

@HiveType(typeId: HiveTypes.curatorEditorEntity)
class CuratorEditorEntity {
  CuratorEditorEntity({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatar,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String bio;
  @HiveField(3)
  final ImageEntity? avatar;
}

@HiveType(typeId: HiveTypes.curatorEditorialTeamEntity)
class CuratorEditorialTeamEntity {
  CuratorEditorialTeamEntity({
    required this.name,
    required this.bio,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String bio;
}

@HiveType(typeId: HiveTypes.curatorUnknownEntity)
class CuratorUnknownEntity {}
