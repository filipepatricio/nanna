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
                  child: _ArticleOpacity(
                    article: state.map(
                      initializing: (_) => article,
                      idle: (state) => state.article,
                      offline: (state) => state.article,
                    ),
                    available: state.maybeMap(offline: (_) => false, orElse: () => true),
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
                _ArticleAspectRatioImageCover(
                  article: article,
                  coverColor: article.category.color,
                  aspectRatio: AppDimens.articleSmallCoverAspectRatio,
                  width: coverWidth,
                  available: state.maybeMap(offline: (_) => false, orElse: () => true),
                ),
              ],
            ),
            if (articleNote != null && article.shouldShowArticleCoverNote && showNote) ...[
              const SizedBox(height: AppDimens.m),
              _ArticleOpacity(
                article: state.map(
                  initializing: (_) => article,
                  idle: (state) => state.article,
                  offline: (state) => state.article,
                ),
                available: state.maybeMap(offline: (_) => false, orElse: () => true),
                child: OwnersNote(
                  note: articleNote,
                  isNoteCollapsible: article.isNoteCollapsible,
                  showRecommendedBy: showRecommendedBy,
                  curationInfo: article.curationInfo,
                  onTap: onTap,
                ),
              ),
            ],
            const SizedBox(height: AppDimens.sl),
            ArticleMetadataRow(
              article: state.map(
                initializing: (_) => article,
                idle: (state) => state.article,
                offline: (state) => state.article,
              ),
              isNew: isNew,
              onBookmarkTap: onBookmarkTap,
            ),
          ],
        ),
      ),
    );
  }
}
