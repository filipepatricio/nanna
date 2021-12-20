import 'package:better_informed_mobile/domain/daily_brief/data/image.dart';

abstract class TopicOwner {
  const TopicOwner({required this.name, this.avatar});

  final Image? avatar;
  final String name;
}

class Editor extends TopicOwner {
  const Editor({required String name, Image? avatar}) : super(avatar: avatar, name: name);
}

class Expert extends TopicOwner {
  const Expert({
    required this.id,
    required String name,
    required this.bio,
    Image? avatar,
  }) : super(avatar: avatar, name: name);

  final String id;
  final String bio;
}
