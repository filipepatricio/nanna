part of 'article_cover.dart';

class _ArticleCoverList extends ArticleCover {
  const _ArticleCoverList({
    required this.onTap,
    required this.article,
    required this.snackbarController,
    required this.showNote,
    required this.showRecommendedBy,
    Key? key,
  }) : super._(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final SnackbarController snackbarController;
  final bool showNote;
  final bool showRecommendedBy;

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
          if (article.shouldShowArticleCoverNote && showNote) ...[
            InformedMarkdownBody(
              markdown: article.note!,
              baseTextStyle: AppTypography.b2Regular.copyWith(),
            ),
            const SizedBox(height: AppDimens.s),
          ],
          if (showRecommendedBy) const ArticleRecommendedByView(),
          const SizedBox(height: AppDimens.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PublisherRow(publisher: article.publisher),
                    const SizedBox(height: AppDimens.xs),
                    Text(
                      article.strippedTitle,
                      style: AppTypography.articleSmallTitle,
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
            snackbarController: snackbarController,
          ),
        ],
      ),
    );
  }
}
