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
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();
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
        onTap: () => state.maybeMap(
          offline: (_) => snackbarController.showMessage(SnackbarMessage.offline(context)),
          orElse: onTap,
        ),
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
                        Text(
                          article.strippedTitle,
                          style: AppTypography.serifTitleLargeIvar,
                          maxLines: article.hasImage ? 4 : null,
                          overflow: article.hasImage ? TextOverflow.ellipsis : null,
                        ),
                      ],
                    ),
                  ),
                ),
                if (article.hasImage) ...[
                  const SizedBox(width: AppDimens.m),
                  _ArticleCoverImage.aspectRatio(
                    article: article,
                    aspectRatio: AppDimens.articleSmallCoverAspectRatio,
                    width: coverWidth,
                    available: state.maybeMap(offline: (_) => false, orElse: () => true),
                  ),
                ],
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
            _ArticleCoverMetadataRow(
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
