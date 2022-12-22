part of 'article_cover.dart';

class _ArticleCoverLarge extends ArticleCover {
  const _ArticleCoverLarge({
    required this.article,
    required this.onTap,
    required this.showNote,
    required this.showRecommendedBy,
    Key? key,
  }) : super._(key: key);

  final MediaItemArticle article;
  final VoidCallback onTap;
  final bool showNote;
  final bool showRecommendedBy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (article.hasImage) ...[
            const SizedBox(height: AppDimens.m),
            _ArticleAspectRatioCover(
              article: article,
              coverColor: article.category.color,
              aspectRatio: _articleLargeCoverAspectRatio,
              width: double.infinity,
            ),
          ],
          const SizedBox(height: AppDimens.m),
          ArticleProgressOpacity(
            article: article,
            child: Column(
              children: [
                PublisherRow(article: article),
                const SizedBox(height: AppDimens.s),
                Text(
                  article.strippedTitle,
                  style: AppTypography.articleTitle.copyWith(
                    fontSize: 26,
                    letterSpacing: 0.02,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.m),
          if (article.shouldShowArticleCoverNote && showNote) ...[
            OwnersNoteContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InformedMarkdownBody(
                    markdown: article.note!,
                    baseTextStyle:
                        AppTypography.sansTextSmallLausanne.copyWith(color: AppColors.of(context).textSecondary),
                  ),
                  if (showRecommendedBy) ...[
                    const SizedBox(height: AppDimens.xs),
                    CurationInfoView(curationInfo: article.curationInfo),
                  ]
                ],
              ),
            ),
            const SizedBox(height: AppDimens.m),
          ],
          ArticleMetadataRow(
            article: article,
          ),
        ],
      ),
    );
  }
}
