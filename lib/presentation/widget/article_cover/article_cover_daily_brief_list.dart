part of 'article_cover.dart';

class _ArticleCoverDailyBriefListItem extends HookWidget {
  const _ArticleCoverDailyBriefListItem({
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
      child: CoverOpacity.article(
        article: article,
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
                    Row(
                      children: [
                        PublisherLogo.dark(publisher: article.publisher),
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
                    const Spacer(),
                    Text(
                      article.strippedTitle,
                      maxLines: 2,
                      style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Flexible(
                      child: ArticleDottedInfo(
                        article: article,
                        isLight: false,
                        showLogo: false,
                        showPublisher: false,
                        showDate: false,
                        textStyle: AppTypography.caption1Medium,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
