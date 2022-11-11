import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_metadata_row.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_no_image_view.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_image.dart';
import 'package:better_informed_mobile/presentation/widget/curation/curation_info_view.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'article_cover_large.dart';
part 'article_cover_list.dart';
part 'article_cover_small.dart';
part 'content/article_square_cover.dart';

const _coverSizeToScreenWidthFactor = 0.27;
const _articleLargeCoverAspectRatio = 343 / 218;
const _articleSmallCoverAspectRatio = 120 / 100;

abstract class ArticleCover extends HookWidget {
  const ArticleCover._({super.key}) : super();

  factory ArticleCover.large({
    required MediaItemArticle article,
    required VoidCallback onTap,
    bool showNote = false,
    bool showRecommendedBy = false,
    Key? key,
  }) {
    return _ArticleCoverLarge(
      article: article,
      onTap: onTap,
      showNote: showNote,
      showRecommendedBy: showRecommendedBy,
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

  factory ArticleCover.list({
    required MediaItemArticle article,
    required VoidCallback onTap,
    bool showNote = false,
    bool showRecommendedBy = false,
    VoidCallback? onBookmarkTap,
    Key? key,
  }) {
    return _ArticleCoverList(
      article: article,
      onTap: onTap,
      showNote: showNote,
      showRecommendedBy: showRecommendedBy,
      onBookmarkTap: onBookmarkTap,
      key: key,
    );
  }
}
