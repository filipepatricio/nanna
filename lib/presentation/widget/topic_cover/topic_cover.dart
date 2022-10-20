import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/widgets/cover_opacity.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/visited_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'topic_cover_bookmark.dart';
part 'topic_cover_content.dart';
part 'topic_cover_daily_brief.dart';
part 'topic_cover_other_brief_items_list.dart';
part 'topic_cover_small.dart';

enum TopicCoverType { bookmark, dailyBrief, small, otherBriefItemsList }

const _coverSizeToScreenWidthFactor = 0.26;

class TopicCover extends HookWidget {
  factory TopicCover.dailyBrief({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.dailyBrief,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.bookmark({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.bookmark,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.small({
    required TopicPreview topic,
    required SnackbarController snackbarController,
    Function()? onTap,
  }) =>
      TopicCover._(
        type: TopicCoverType.small,
        topic: topic,
        onTap: onTap,
        snackbarController: snackbarController,
      );

  factory TopicCover.otherBriefItemsList({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.otherBriefItemsList,
        topic: topic,
        onTap: onTap,
      );

  const TopicCover._({
    required this.topic,
    required this.type,
    this.onTap,
    this.snackbarController,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final Function()? onTap;
  final SnackbarController? snackbarController;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.small:
        return _TopicCoverSmall(
          topic: topic,
          snackbarController: snackbarController!,
          onTap: onTap,
        );
      case TopicCoverType.bookmark:
        return _TopicCoverBookmark(
          topic: topic,
          onTap: onTap,
        );
      case TopicCoverType.dailyBrief:
        return _TopicCoverDailyBrief(
          onTap: onTap,
          topic: topic,
        );
      case TopicCoverType.otherBriefItemsList:
        return _TopicCoverOtherBriefItemsList(
          onTap: onTap,
          topic: topic,
        );
    }
  }
}
