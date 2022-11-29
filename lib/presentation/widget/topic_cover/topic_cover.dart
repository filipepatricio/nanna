import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/color_extension.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'topic_cover_bar.dart';
part 'topic_cover_big.dart';
part 'topic_cover_bookmark.dart';
part 'topic_cover_small.dart';

enum TopicCoverType { big, small, list }

class TopicCover extends HookWidget {
  factory TopicCover.big({
    required TopicPreview topic,
    VoidCallback? onTap,
    VoidCallback? onBookmarkTap,
    Key? key,
  }) =>
      TopicCover._(
        key: key,
        type: TopicCoverType.big,
        topic: topic,
        onTap: onTap,
        onBookmarkTap: onBookmarkTap,
      );

  factory TopicCover.small({
    required TopicPreview topic,
    VoidCallback? onTap,
    Key? key,
  }) =>
      TopicCover._(
        key: key,
        type: TopicCoverType.small,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.list({
    required TopicPreview topic,
    VoidCallback? onTap,
    VoidCallback? onBookmarkTap,
  }) =>
      TopicCover._(
        type: TopicCoverType.list,
        topic: topic,
        onTap: onTap,
        onBookmarkTap: onBookmarkTap,
      );

  const TopicCover._({
    required this.topic,
    required this.type,
    this.onBookmarkTap,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.small:
        return _TopicCoverSmall(
          topic: topic,
          onTap: onTap,
        );
      case TopicCoverType.big:
        return _TopicCoverBig(
          topic: topic,
          onBookmarkTap: onBookmarkTap,
          onTap: onTap,
        );
      case TopicCoverType.list:
        return _TopicCoverList(
          topic: topic,
          onTap: onTap,
          onBookmarkTap: onBookmarkTap,
        );
    }
  }
}
