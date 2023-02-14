import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cubit_hooks.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/article_cover_cubit.di.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_no_image_view.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label.dart';
import 'package:better_informed_mobile/presentation/widget/audio/control_button/audio_control_button.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/category_dot.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_svg.dart';
import 'package:better_informed_mobile/presentation/widget/new_tag.dart';
import 'package:better_informed_mobile/presentation/widget/owners_note.dart';
import 'package:better_informed_mobile/presentation/widget/pipe_divider.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'article_cover_large.dart';
part 'article_cover_medium.dart';
part 'article_cover_small.dart';
part 'article_opacity.dart';
part 'content/article_cover_image.dart';
part 'content/article_cover_metadata_row.dart';
part 'content/article_cover_audio_button.dart';

abstract class ArticleCover extends HookWidget {
  const ArticleCover._({super.key}) : super();

  factory ArticleCover.large({
    required MediaItemArticle article,
    required VoidCallback onTap,
    bool isNew = false,
    bool showNote = false,
    bool showRecommendedBy = false,
    Key? key,
  }) {
    return _ArticleCoverLarge(
      article: article,
      onTap: onTap,
      isNew: isNew,
      showNote: showNote,
      showRecommendedBy: showRecommendedBy,
      key: key,
    );
  }

  factory ArticleCover.medium({
    required MediaItemArticle article,
    required VoidCallback onTap,
    bool isNew = false,
    bool showNote = true,
    bool showRecommendedBy = true,
    VoidCallback? onBookmarkTap,
    Key? key,
  }) {
    return _ArticleCoverMedium(
      article: article,
      onTap: onTap,
      isNew: isNew,
      showNote: showNote,
      showRecommendedBy: showRecommendedBy,
      onBookmarkTap: onBookmarkTap,
      key: key,
    );
  }

  factory ArticleCover.small({
    required MediaItemArticle article,
    required VoidCallback onTap,
    Key? key,
  }) {
    return _ArticleCoverSmall(
      article: article,
      onTap: onTap,
      key: key,
    );
  }
}
