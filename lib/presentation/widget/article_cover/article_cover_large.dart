part of 'article_cover.dart';

class _ArticleCoverLarge extends ArticleCover {
  const _ArticleCoverLarge({
    required this.article,
    required this.onTap,
    required this.isNew,
    required this.showNote,
    required this.showRecommendedBy,
    Key? key,
  }) : super._(key: key);

  final MediaItemArticle article;
  final VoidCallback onTap;
  final bool isNew;
  final bool showNote;
  final bool showRecommendedBy;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<ArticleCoverCubit>();
    final state = useCubitBuilder(cubit);
    final articleNote = article.note;

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
            if (article.hasImage) ...[
              _ArticleAspectRatioCover(
                article: article,
                coverColor: article.category.color,
                aspectRatio: AppDimens.articleLargeCoverAspectRatio,
                width: double.infinity,
              ),
              const SizedBox(height: AppDimens.m),
            ],
            ArticleProgressOpacity(
              article: state.map(initializing: (_) => article, idle: (state) => state.article),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
            if (articleNote != null && article.shouldShowArticleCoverNote && showNote) ...[
              OwnersNote(
                note: articleNote,
                showRecommendedBy: showRecommendedBy,
                curationInfo: article.curationInfo,
              ),
              const SizedBox(height: AppDimens.m),
            ],
            ArticleMetadataRow(
              article: state.map(initializing: (_) => article, idle: (state) => state.article),
              isNew: isNew,
            ),
          ],
        ),
      ),
    );
  }
}
