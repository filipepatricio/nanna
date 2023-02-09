part of 'article_cover.dart';

class _ArticleCoverMedium extends ArticleCover {
  const _ArticleCoverMedium({
    required this.onTap,
    required this.article,
    required this.isNew,
    required this.showNote,
    required this.showRecommendedBy,
    this.onBookmarkTap,
    Key? key,
  }) : super._(key: key);

  final MediaItemArticle article;
  final bool isNew;
  final bool showNote;
  final bool showRecommendedBy;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final coverWidth = useMemoized(
      () => AppDimens.coverSize(context, AppDimens.coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    final articleNote = article.note;
    final cubit = useCubit<ArticleCoverCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize(article);
      },
      [cubit, article],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pageHorizontalMargin,
        vertical: AppDimens.l,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ArticleProgressOpacity(
                    article: state.map(initializing: (_) => article, idle: (state) => state.article),
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
                  aspectRatio: AppDimens.articleSmallCoverAspectRatio,
                  width: coverWidth,
                ),
              ],
            ),
            if (articleNote != null && article.shouldShowArticleCoverNote && showNote) ...[
              const SizedBox(height: AppDimens.m),
              OwnersNote(
                note: articleNote,
                showRecommendedBy: showRecommendedBy,
                curationInfo: article.curationInfo,
              ),
            ],
            const SizedBox(height: AppDimens.sl),
            ArticleMetadataRow(
              article: state.map(initializing: (_) => article, idle: (state) => state.article),
              isNew: isNew,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}
