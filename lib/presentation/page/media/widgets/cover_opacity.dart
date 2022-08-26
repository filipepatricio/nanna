import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CoverOpacity extends HookWidget {
  const CoverOpacity._({
    required this.child,
    this.article,
    this.topic,
    Key? key,
  }) : super(key: key);

  factory CoverOpacity.article({
    required Widget child,
    required MediaItemArticle article,
  }) =>
      CoverOpacity._(
        article: article,
        child: child,
      );

  factory CoverOpacity.topic({
    required Widget child,
    required TopicPreview topic,
  }) =>
      CoverOpacity._(
        topic: topic,
        child: child,
      );

  final Widget child;
  final MediaItemArticle? article;
  final TopicPreview? topic;

  @override
  Widget build(BuildContext context) {
    final visited = useMemoized(
      () {
        if (article != null) {
          return article!.visited;
        } else if (topic != null) {
          return topic!.visited;
        }

        return false;
      },
      [topic, article],
    );

    return Opacity(
      opacity: visited ? 0.4 : 1,
      child: child,
    );
  }
}
