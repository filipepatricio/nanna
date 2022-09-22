import 'package:better_informed_mobile/domain/image/data/image.dart';

abstract class TopicOwner {
  const TopicOwner({
    required this.id,
    required this.name,
    required this.bio,
    this.avatar,
  });

  final String id;
  final String name;
  final String bio;
  final Image? avatar;
}

class Editor extends TopicOwner {
  const Editor({
    required String id,
    required String name,
    required String bio,
    Image? avatar,
  }) : super(
          id: id,
          name: name,
          bio: bio,
          avatar: avatar,
        );
}

class Expert extends TopicOwner {
  const Expert({
    required String id,
    required String name,
    required String bio,
    required this.areaOfExpertise,
    this.instagram,
    this.linkedin,
    this.website,
    this.twitter,
    Image? avatar,
  }) : super(
          id: id,
          name: name,
          bio: bio,
          avatar: avatar,
        );

  final String areaOfExpertise;
  final String? instagram;
  final String? linkedin;
  final String? website;
  final String? twitter;

  bool get hasSocialMediaLinks => instagram != null || linkedin != null || website != null;
}

class EditorialTeam extends TopicOwner {
  const EditorialTeam({
    required String name,
    required String bio,
  }) : super(
          id: 'editorial-team',
          name: name,
          bio: bio,
        );
}

class UnknownOwner extends TopicOwner {
  const UnknownOwner() : super(id: '', name: '', bio: '');
}
