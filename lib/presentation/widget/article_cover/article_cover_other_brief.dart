part of 'article_cover.dart';

class _ArticleCoverOtherBriefItemsList extends HookWidget {
  const _ArticleCoverOtherBriefItemsList({
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
      () => MediaQuery.of(context).size.width * _coverSizeToScreenWidthFactor,
      [MediaQuery.of(context).size],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: coverSize,
            child: _CoverImage(
              article: article,
              coverColor: coverColor,
              showArticleIndicator: false,
              borderRadius: AppDimens.xs,
            ),
          ),
          const SizedBox(width: AppDimens.m),
          Expanded(
            child: SizedBox(
              height: coverSize,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoverLabel.article(
                    color: AppColors.white,
                    borderColor: AppColors.dividerGrey,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(AppDimens.xxs),
                    child: AutoSizeText(
                      article.strippedTitle,
                      maxLines: 2,
                      style: AppTypography.h5BoldSmall.copyWith(height: 1.25),
                      overflow: TextOverflow.ellipsis,
                      maxFontSize: 14,
                      minFontSize: 12,
                    ),
                  ),
                  const Spacer(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}