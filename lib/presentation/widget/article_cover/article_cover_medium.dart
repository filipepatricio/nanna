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
            Stack(
              fit: StackFit.loose,
              children: [
                DropCapText(
                  article.strippedTitle,
                  style: AppTypography.serifTitleLargeIvar.copyWith(color: AppColors.of(context).textPrimary),
                  indentation: const Offset(0, AppDimens.smallPublisherLogoSize + AppDimens.sl),
                  dropCapPadding: const EdgeInsets.only(left: AppDimens.m),
                  dropCapPosition: DropCapPosition.end,
                  mode: DropCapMode.baseline,
                  dropCap: DropCap(
                    width: coverWidth,
                    height: coverWidth,
                    child: _ArticleCoverImage.aspectRatio(
                      article: article,
                      aspectRatio: AppDimens.articleSmallCoverAspectRatio,
                      width: coverWidth,
                      available: state.maybeMap(offline: (_) => false, orElse: () => true),
                    ),
                  ),
                ),
                // Perfect solution would be to have overTextWidget field (similar to belowTextWidget) in DropCapText
                // we wouldn't have to set manually indentation, something to improve
                Positioned(
                  top: 0,
                  left: 0,
                  right: coverWidth + AppDimens.m,
                  child: PublisherRow(article: article),
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
