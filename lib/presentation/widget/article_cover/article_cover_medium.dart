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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimens.l),
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
          if (article.shouldShowArticleCoverNote && showNote) ...[
            const SizedBox(height: AppDimens.m),
            _ArticlesNote(article: article, showRecommendedBy: showRecommendedBy),
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
