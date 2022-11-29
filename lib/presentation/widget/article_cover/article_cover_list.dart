part of 'article_cover.dart';

class _ArticleCoverList extends ArticleCover {
  const _ArticleCoverList({
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
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pageHorizontalMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (article.shouldShowArticleCoverNote && showNote) ...[
              InformedMarkdownBody(
                markdown: article.note!,
                baseTextStyle: AppTypography.b2Regular,
              ),
              const SizedBox(height: AppDimens.s),
            ],
            if (showRecommendedBy) CurationInfoView(curationInfo: article.curationInfo),
            const SizedBox(height: AppDimens.m),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PublisherRow(article: article),
                      const SizedBox(height: AppDimens.xs),
                      InformedMarkdownBody(
                        markdown: article.title,
                        baseTextStyle: AppTypography.articleSmallTitle,
                        maxLines: 3,
                      ),
                    ],
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
            const SizedBox(height: AppDimens.sl),
            ArticleMetadataRow(
              article: article,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}
