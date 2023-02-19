part of '../article_cover.dart';

class _ArticleCoverMetadataRow extends StatelessWidget {
  const _ArticleCoverMetadataRow({
    required this.article,
    required this.isNew,
    this.onBookmarkTap,
  });

  final MediaItemArticle article;
  final VoidCallback? onBookmarkTap;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (isNew) ...[
              const NewTag(),
              const SizedBox(width: AppDimens.s),
            ],
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
              _ArticleCoverAudioButton(
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
