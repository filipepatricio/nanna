part of 'article_cover.dart';

class _ArticleCoverBookmark extends HookWidget {
  const _ArticleCoverBookmark({
    required this.onTap,
    required this.article,
    required this.coverColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;
  final MediaItemArticle article;
  final Color? coverColor;

  @override
  Widget build(BuildContext context) {
    final coverSize = useMemoized(
      () => AppDimens.coverSize(context, _coverSizeToScreenWidthFactor),
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          _ArticleSquareCover(
            article: article,
            coverColor: coverColor,
            showArticleIndicator: false,
            dimension: coverSize,
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: AppDimens.s),
                  Row(
                    children: [
                      PublisherLogo.dark(
                        publisher: article.publisher,
                        dimension: AppDimens.ml,
                      ),
                      Flexible(
                        child: Text(
                          article.publisher.name,
                          maxLines: 1,
                          style: AppTypography.caption1Medium.copyWith(color: AppColors.textGrey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.s),
                  Text(
                    article.strippedTitle,
                    maxLines: 3,
                    style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
