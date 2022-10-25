import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/share/topic_articles_select_view.dart';
import 'package:better_informed_mobile/presentation/widget/share_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_bar_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_cover_bar_state.dt.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner/topic_owner_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'topic_cover_bar.dart';
part 'topic_cover_big.dart';
part 'topic_cover_bookmark.dart';
part 'topic_cover_small.dart';

enum TopicCoverType { big, small, bookmark }

class TopicCover extends HookWidget {
  factory TopicCover.big({
    required TopicPreview topic,
    required SnackbarController snackbarController,
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
        snackbarController: snackbarController,
      );

  factory TopicCover.small({
    required TopicPreview topic,
    required SnackbarController snackbarController,
    VoidCallback? onTap,
    Key? key,
  }) =>
      TopicCover._(
        key: key,
        type: TopicCoverType.small,
        topic: topic,
        onTap: onTap,
        snackbarController: snackbarController,
      );

  factory TopicCover.bookmark({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.bookmark,
        topic: topic,
        onTap: onTap,
      );

  const TopicCover._({
    required this.topic,
    required this.type,
    this.snackbarController,
    this.onBookmarkTap,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final SnackbarController? snackbarController;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.small:
        return _TopicCoverSmall(
          topic: topic,
          snackbarController: snackbarController!,
          onTap: onTap,
        );
      case TopicCoverType.big:
        return _TopicCoverBig(
          topic: topic,
          snackbarController: snackbarController!,
          onBookmarkTap: onBookmarkTap,
          onTap: onTap,
        );
      case TopicCoverType.bookmark:
        return _TopicCoverBookmark(
          topic: topic,
          onTap: onTap,
        );
    }
  }
}
