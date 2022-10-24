import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/informed_pill.dart';
import 'package:better_informed_mobile/presentation/widget/share/article_button/share_article_button.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/material.dart';

class ArticleMetadataRow extends StatelessWidget {
  const ArticleMetadataRow({
    required this.article,
    required this.snackbarController,
    super.key,
  });

  final MediaItemArticle article;
  final SnackbarController snackbarController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!article.visited) ...[
              InformedPill(
                title: article.category.name,
                color: article.category.color,
              ),
              const SizedBox(width: AppDimens.s),
            ],
            ArticleTimeReadLabel(
              visited: article.visited,
              timeToRead: article.timeToRead,
            ),
          ],
        ),
        const Spacer(),
        Wrap(
          children: [
            ShareArticleButton(
              article: article,
              snackbarController: snackbarController,
              backgroundColor: AppColors.transparent,
            ),
            const SizedBox(width: AppDimens.s),
            BookmarkButton.article(
              article: article,
              snackbarController: snackbarController,
            ),
            if (article.hasAudioVersion) ...[
              const SizedBox(width: AppDimens.s),
              AudioIconButton(
                article: article,
                height: AppDimens.xl,
              ),
            ]
          ],
        ),
      ],
    );
  }
}
