part of 'article_cover.dart';

class _ArticleCoverSmall extends ArticleCover {
  const _ArticleCoverSmall({
    required this.onTap,
    required this.article,
    Key? key,
  }) : super._(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final height = useMemoized(
      () => AppDimens.smallCardHeight(context),
      [MediaQuery.of(context).size],
    );

    final cubit = useCubit<ArticleCoverCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(
      () {
        cubit.initialize(article);
      },
      [cubit, article],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ArticleSquareImageCover(
                article: article,
                coverColor: article.category.color,
                dimension: constraints.maxWidth,
                available: state.maybeMap(offline: (_) => false, orElse: () => true),
              ),
              const SizedBox(height: AppDimens.sl),
              Expanded(
                child: _ArticleOpacity(
                  article: state.map(
                    initializing: (_) => article,
                    idle: (state) => state.article,
                    offline: (state) => state.article,
                  ),
                  available: state.maybeMap(offline: (_) => false, orElse: () => true),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PublisherRow(article: article),
                      const SizedBox(height: AppDimens.sl),
                      InformedMarkdownBody(
                        maxLines: 4,
                        markdown: article.title,
                        highlightColor: AppColors.transparent,
                        baseTextStyle: AppTypography.serifTitleSmallIvar,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ArticleTimeReadLabel(
                    article: state.map(
                      initializing: (_) => article,
                      idle: (state) => state.article,
                      offline: (state) => state.article,
                    ),
                  ),
                  const Spacer(),
                  BookmarkButton.article(article: article),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
