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
              _ArticleSquareCover(
                article: article,
                coverColor: article.category.color,
                dimension: constraints.maxWidth,
              ),
              const SizedBox(height: AppDimens.sl),
              Expanded(
                child: ArticleProgressOpacity(
                  article: article,
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
                  ArticleTimeReadLabel(article: article),
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
