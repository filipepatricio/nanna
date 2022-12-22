part of 'article_cover.dart';

class _ArticleCoverMedium extends ArticleCover {
  const _ArticleCoverMedium({
    required this.onTap,
    required this.article,
    required this.showNote,
    required this.showRecommendedBy,
    this.onBookmarkTap,
    Key? key,
  }) : super._(key: key);

  final MediaItemArticle article;
  final bool showNote;
  final bool showRecommendedBy;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final coverWidth = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    final articleNote = article.note;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
          if (article.shouldShowArticleCoverNote && showNote) ...[
            InformedMarkdownBody(
              markdown: article.note!,
              baseTextStyle: AppTypography.b2Regular,
            ),
            const SizedBox(height: AppDimens.s),
          ],
          if (showRecommendedBy) ...[
            CurationInfoView(curationInfo: article.curationInfo),
            const SizedBox(height: AppDimens.m),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ArticleProgressOpacity(
                  article: article,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PublisherRow(article: article),
                      const SizedBox(height: AppDimens.sl),
                      InformedMarkdownBody(
                        markdown: article.title,
                        baseTextStyle: AppTypography.serifTitleLargeIvar,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.m),
              _ArticleAspectRatioCover(
                article: article,
                coverColor: article.category.color,
                aspectRatio: _articleSmallCoverAspectRatio,
                width: coverWidth,
              ),
            ],
          ),
          if (articleNote != null) ...[
            const SizedBox(height: AppDimens.m),
            OwnersNoteContainer(
              child: InformedMarkdownBody(
                markdown: articleNote,
                baseTextStyle: AppTypography.sansTextSmallLausanne.copyWith(
                  color: AppColors.of(context).textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.sl)
          ],
          const SizedBox(height: AppDimens.sl),
          ArticleMetadataRow(
            article: article,
            onBookmarkTap: onBookmarkTap,
          ),
          const SizedBox(height: AppDimens.l),
        ],
      ),
    );
  }
}
