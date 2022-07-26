import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/cover_label/cover_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_cover_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_owner_avatar.dart';
import 'package:better_informed_mobile/presentation/widget/updated_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'topic_cover_bookmark.dart';
part 'topic_cover_content.dart';
part 'topic_cover_daily_brief.dart';
part 'topic_cover_explore_large.dart';
part 'topic_cover_explore_small.dart';
part 'topic_cover_other_brief_items_list.dart';

enum TopicCoverType { bookmark, dailyBrief, exploreLarge, exploreSmall, otherBriefItemsList }

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

  factory TopicCover.exploreLarge({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.exploreLarge,
        topic: topic,
        onTap: onTap,
      );

  factory TopicCover.exploreSmall({required TopicPreview topic, bool hasBackgroundColor = false, Function()? onTap}) =>
      TopicCover._(
        type: TopicCoverType.exploreSmall,
        topic: topic,
        onTap: onTap,
        hasBackgroundColor: hasBackgroundColor,
      );

  factory TopicCover.otherBriefItemsList({required TopicPreview topic, Function()? onTap}) => TopicCover._(
        type: TopicCoverType.otherBriefItemsList,
        topic: topic,
        onTap: onTap,
      );

  const TopicCover._({
    required this.topic,
    required this.type,
    this.hasBackgroundColor = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final TopicPreview topic;
  final TopicCoverType type;
  final bool hasBackgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TopicCoverType.exploreSmall:
        return _TopicCoverExploreSmall(
          topic: topic,
          hasBackgroundColor: hasBackgroundColor,
          onTap: onTap,
        );
      case TopicCoverType.exploreLarge:
        return _TopicCoverExploreLarge(
          topic: topic,
          onTap: onTap,
        );
      case TopicCoverType.bookmark:
        return _TopicCoverBookmark(
          topic: topic,
          hasBackgroundColor: hasBackgroundColor,
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
