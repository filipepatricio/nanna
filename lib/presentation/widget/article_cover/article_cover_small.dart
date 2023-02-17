part of 'article_cover.dart';

class _ArticleCoverSmall extends ArticleCover {
  const _ArticleCoverSmall({
    required this.onTap,
    required this.article,
    Key? key,
  }) : super._(key: key);

  final VoidCallback onTap;
  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final snackbarController = useSnackbarController();
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
      onTap: () => state.maybeMap(
        offline: (_) => snackbarController.showMessage(SnackbarMessage.offline(context)),
        orElse: onTap,
      ),
      child: SizedBox(
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ArticleCoverImage.square(
                article: article,
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
                      Text(
                        article.strippedTitle,
                        maxLines: 4,
                        style: AppTypography.serifTitleSmallIvar,
                        overflow: TextOverflow.ellipsis,
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
