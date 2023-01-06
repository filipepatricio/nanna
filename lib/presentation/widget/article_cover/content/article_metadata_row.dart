import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/article_cover/content/article_time_read_label.dart';
import 'package:better_informed_mobile/presentation/widget/audio_icon.dart';
import 'package:better_informed_mobile/presentation/widget/bookmark_button/bookmark_button.dart';
import 'package:better_informed_mobile/presentation/widget/category_dot.dart';
import 'package:better_informed_mobile/presentation/widget/pipe_divider.dart';
import 'package:flutter/material.dart';

class ArticleMetadataRow extends StatelessWidget {
  const ArticleMetadataRow({
    required this.article,
    this.onBookmarkTap,
    super.key,
  });

  final MediaItemArticle article;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (!article.finished) ...[
              CategoryDot(
                category: article.category,
                labelColor: AppColors.of(context).textSecondary,
              ),
              const SizedBox(width: AppDimens.s),
              const PipeDivider(),
              const SizedBox(width: AppDimens.s),
            ],
            ArticleTimeReadLabel(article: article),
          ],
        ),
        const Spacer(),
        Wrap(
          children: [
            BookmarkButton.article(
              article: article,
              onTap: onBookmarkTap,
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
