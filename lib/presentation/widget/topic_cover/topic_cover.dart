import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo_row.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/image/topic_image.dart';
import 'package:better_informed_mobile/presentation/widget/topic_cover/topic_square_image_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'topic_cover_bar.dart';
part 'topic_cover_large.dart';
part 'topic_cover_medium.dart';
part 'topic_cover_small.dart';

abstract class TopicCover extends HookWidget {
  const TopicCover._({super.key}) : super();

  factory TopicCover.large({
    required TopicPreview topic,
    VoidCallback? onTap,
    Key? key,
  }) =>
      _TopicCoverLarge(
        topic: topic,
        onTap: onTap,
        key: key,
      );

  factory TopicCover.medium({
    required TopicPreview topic,
    VoidCallback? onTap,
    VoidCallback? onBookmarkTap,
    Key? key,
  }) =>
      _TopicCoverMedium(
        topic: topic,
        onTap: onTap,
        onBookmarkTap: onBookmarkTap,
        key: key,
      );

  factory TopicCover.small({
    required TopicPreview topic,
    VoidCallback? onTap,
    Key? key,
  }) =>
      _TopicCoverSmall(
        topic: topic,
        onTap: onTap,
        key: key,
      );
}
